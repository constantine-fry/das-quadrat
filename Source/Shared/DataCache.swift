//
//  DataCache.swift
//  Quadrat
//
//  Created by Constantine Fry on 01/12/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#endif

/** Configs for data cache. */
struct DataCacheConfiguration {
    
    /** Time to keep a data in cache in seconds. Default is 1 week.  */
    private let maxCacheAge         = (60 * 60 * 24 * 7) as NSTimeInterval
    
    /** The maximum size for disk cache in bytes. Default is 10MB. */
    private let maxDiskCacheSize    = (1024 * 1024 * 10) as UInt
    
    /** The maximum size for memory cache in bytes. Default is 10MB. */
    private let maxMemoryCacheSize  = (1024 * 1024 * 10) as UInt
}

/** The queue for I/O operations. Shared between several instances. */
private let privateQueue    = NSOperationQueue()

/** Responsible for caching data on disk and memory. Thread safe. */
class DataCache {
    
    /** Logger to log all errors. */
    var logger : Logger?
    
    /** The URL to directory where we put all the files. */
    private let directoryURL: NSURL
    
    /** In memory cache for NSData. */
    private let cache           = NSCache()
    
    /** Obsever objects from NSNotificationCenter. */
    private var observers       = [AnyObject]()
    
    /** The file manager to use for all file operations. */
    private let fileManager     = NSFileManager.defaultManager()
    
    /** The configuration for cache. */
    private let cacheConfiguration  = DataCacheConfiguration()
    
    init(name: String?) {
        cache.totalCostLimit = Int(cacheConfiguration.maxMemoryCacheSize);
        let directoryName = "net.foursquare.quadrat"
        let subdirectiryName = (name != nil) ? ( "Cache" + name! ) : "DefaultCache"
        let cacheURL: NSURL?
        do {
            cacheURL = try fileManager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask,
                        appropriateForURL: nil, create: true)
        } catch _ {
            fatalError("Can't get access to cache directory")
        }
        self.directoryURL = cacheURL!.URLByAppendingPathComponent("\(directoryName)/DataCache/\(subdirectiryName)")
        privateQueue.maxConcurrentOperationCount = 1
        createBaseDirectory()
        subscribeForNotifications()
    }
    
    deinit {
        for observer in observers {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
    /** Returns data for key. */
    func dataForKey(key: String) -> NSData? {
        var result: NSData?
        privateQueue.addOperationWithBlock {
            result = self.cache.objectForKey(key) as? NSData
            if result == nil {
                let targetURL = self.directoryURL.URLByAppendingPathComponent(key)
                result = NSData(contentsOfURL: targetURL)
                if result != nil {
                    self.cache.setObject(result!, forKey: key, cost: result!.length)
                }
            }
        }
        privateQueue.waitUntilAllOperationsAreFinished()
        return result
    }
    
    /** Copies file into cache. */
    func addFileAtURL(URL: NSURL, withKey key: String) {
        privateQueue.addOperationWithBlock { () -> Void in
            let targetURL = self.directoryURL.URLByAppendingPathComponent(key)
            do {
                try self.fileManager.copyItemAtURL(URL, toURL: targetURL)
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't copy file into cache directory.")
            } catch {
            }
        }
        privateQueue.waitUntilAllOperationsAreFinished()
    }
    
    /** Saves data into cache. */
    func addData(data: NSData, withKey key: String) {
        privateQueue.addOperationWithBlock { () -> Void in
            let targetURL = self.directoryURL.URLByAppendingPathComponent(key)
            do {
                try data.writeToURL(targetURL, options: .DataWritingAtomic)
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't save file into cache directory.")
            } catch {
            }
        }
    }
    
    /** Subcribes for iOS specific notifications to perform cache cleaning. */
    private func subscribeForNotifications() {
        #if os(iOS)
            
            let center = NSNotificationCenter.defaultCenter()
            let didEnterBackground = UIApplicationDidEnterBackgroundNotification
            let firstObserver = center.addObserverForName(didEnterBackground, object: nil, queue: nil) {
                [weak self] (notification) -> Void in
                self?.cleanupCache()
                self?.cache.removeAllObjects()
            }
            observers.append(firstObserver)
            
            let didReceiveMemoryWaring = UIApplicationDidReceiveMemoryWarningNotification
            let secondObserver = center.addObserverForName(didReceiveMemoryWaring, object: nil, queue: nil) {
                [weak self] (notification) -> Void in
                self?.cache.removeAllObjects()
            }
            observers.append(secondObserver)
        #endif
    }
    
    /** Creates base directory. */
    private func createBaseDirectory() {
        do {
            try fileManager.createDirectoryAtURL(directoryURL,
                        withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            self.logger?.logError(error, withMessage: "Cache can't create base directory.")
        }
    }
    
    /** Removes all cached files. */
    func clearCache() {
        privateQueue.addOperationWithBlock {
            self.cache.removeAllObjects()
            do {
                try self.fileManager.removeItemAtURL(self.directoryURL)
                self.createBaseDirectory()
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't remove base directory.")
            } catch {
            }
        }
    }
    
    /** Removes expired files. In addition removes 1/4 of files if total size exceeds `maxDiskCacheSize`. */
    private func cleanupCache() {
        privateQueue.addOperationWithBlock {
            let expirationDate = NSDate(timeIntervalSinceNow: -self.cacheConfiguration.maxCacheAge)
            let properties = [NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey]
            
            var fileURLs = [NSURL]()
            do {
                fileURLs = try self.fileManager.contentsOfDirectoryAtURL(self.directoryURL,
                    includingPropertiesForKeys: properties, options: .SkipsHiddenFiles)
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't get properties of files in base directory.")
                return
            } catch {
                return
            }
            
            var cacheSize: UInt = 0
            var expiredFiles = [NSURL]()
            var validFiles = [NSURL]()
            
            /** Searching for expired files and calculation total size. */
            for aFileURL in fileURLs {
                let values: [String : AnyObject]
                do {
                    values = try aFileURL.resourceValuesForKeys(properties)
                } catch {
                    continue
                }

                if let modificationDate = values[NSURLContentModificationDateKey] as? NSDate {
                    if modificationDate.laterDate(expirationDate).isEqualToDate(modificationDate) {
                        validFiles.append(aFileURL)
                        if let fileSize = values[NSURLTotalFileAllocatedSizeKey] as? UInt {
                            cacheSize += fileSize
                        }
                    } else {
                        expiredFiles.append(aFileURL)
                    }
                }
            }

            if cacheSize > self.cacheConfiguration.maxDiskCacheSize {
                /** Sorting files by modification date. From oldest to newest. */
                validFiles.sortInPlace {
                    (url1: NSURL, url2: NSURL) -> Bool in
                    let dateKey = [NSURLContentModificationDateKey]
                    do {
                        let values1 = try url1.resourceValuesForKeys(dateKey) as? [String: NSDate]
                        let values2 = try url2.resourceValuesForKeys(dateKey) as? [String: NSDate]
                        if let date1 = values1?[NSURLContentModificationDateKey] {
                            if let date2 = values2?[NSURLContentModificationDateKey] {
                                return date1.compare(date2) == .OrderedAscending
                            }
                        }
                    } catch {
                      return false
                    }
                    return false
                }
                
                /** Let's just remove 1/4 of all files. */
                validFiles.removeRange(Range(start: 0, end: validFiles.count / 4))
                expiredFiles += validFiles
            }

            for URL in expiredFiles {
                do {
                    try self.fileManager.removeItemAtURL(URL as NSURL)
                } catch let error as NSError {
                     self.logger?.logError(error, withMessage: "Cache can't remove file.")
                } catch {
                }
            }
        }
    }
    
}
