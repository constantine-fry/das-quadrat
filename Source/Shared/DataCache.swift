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
    fileprivate let maxCacheAge = (60 * 60 * 24 * 7) as TimeInterval
    
    /** The maximum size for disk cache in bytes. Default is 10MB. */
    fileprivate let maxDiskCacheSize = (1024 * 1024 * 10) as UInt
    
    /** The maximum size for memory cache in bytes. Default is 10MB. */
    fileprivate let maxMemoryCacheSize = (1024 * 1024 * 10) as UInt
}

/** The queue for I/O operations. Shared between several instances. */
private let privateQueue    = OperationQueue()

/** Responsible for caching data on disk and memory. Thread safe. */
class DataCache {
    
    /** Logger to log all errors. */
    var logger: Logger?
    
    /** The URL to directory where we put all the files. */
    fileprivate let directoryURL: URL
    
    /** In memory cache for NSData. */
    fileprivate let cache = NSCache<NSString, NSData>()
    
    /** Obsever objects from NSNotificationCenter. */
    fileprivate var observers = [AnyObject]()
    
    /** The file manager to use for all file operations. */
    fileprivate let fileManager = FileManager.default
    
    /** The configuration for cache. */
    fileprivate let cacheConfiguration  = DataCacheConfiguration()
    
    init(name: String?) {
        cache.totalCostLimit = Int(cacheConfiguration.maxMemoryCacheSize)
        let directoryName = "net.foursquare.quadrat"
        let subdirectiryName = (name != nil) ? ( "Cache" + name! ) : "DefaultCache"
        let cacheURL: URL?
        do {
            cacheURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask,
                        appropriateFor: nil, create: true)
        } catch _ {
            fatalError("Can't get access to cache directory")
        }
        self.directoryURL = cacheURL!.appendingPathComponent("\(directoryName)/DataCache/\(subdirectiryName)")
        privateQueue.maxConcurrentOperationCount = 1
        createBaseDirectory()
        subscribeForNotifications()
    }
    
    deinit {
        self.observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    /** Returns data for key. */
    func dataForKey(_ key: String) -> Data? {
        var result: Data?
        privateQueue.addOperation {
            result = self.cache.object(forKey: key as NSString) as? Data
            if result == nil {
                let targetURL = self.directoryURL.appendingPathComponent(key)
                result = try? Data(contentsOf: targetURL)
                if let result = result {
                    self.cache.setObject(result as NSData, forKey: key as NSString, cost: result.count)
                }
            }
        }
        privateQueue.waitUntilAllOperationsAreFinished()
        return result
    }
    
    /** Copies file into cache. */
    func addFileAtURL(_ URL: Foundation.URL, withKey key: String) {
        privateQueue.addOperation { () -> Void in
            let targetURL = self.directoryURL.appendingPathComponent(key)
            do {
                try self.fileManager.copyItem(at: URL, to: targetURL)
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't copy file into cache directory.")
            } catch {
            }
        }
        privateQueue.waitUntilAllOperationsAreFinished()
    }
    
    /** Saves data into cache. */
    func addData(_ data: Data, withKey key: String) {
        privateQueue.addOperation { () -> Void in
            let targetURL = self.directoryURL.appendingPathComponent(key)
            do {
                try data.write(to: targetURL, options: .atomic)
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't save file into cache directory.")
            } catch {
            }
        }
    }
    
    /** Subcribes for iOS specific notifications to perform cache cleaning. */
    fileprivate func subscribeForNotifications() {
        #if os(iOS)
            
            let center = NotificationCenter.default
            let didEnterBackground = NSNotification.Name.UIApplicationDidEnterBackground
            let firstObserver = center.addObserver(forName: didEnterBackground, object: nil, queue: nil) {
                [weak self] (notification) -> Void in
                self?.cleanupCache()
                self?.cache.removeAllObjects()
            }
            self.observers.append(firstObserver)
            
            let didReceiveMemoryWaring = NSNotification.Name.UIApplicationDidReceiveMemoryWarning
            let secondObserver = center.addObserver(forName: didReceiveMemoryWaring, object: nil, queue: nil) {
                [weak self] (notification) -> Void in
                self?.cache.removeAllObjects()
            }
            self.observers.append(secondObserver)
        #endif
    }
    
    /** Creates base directory. */
    fileprivate func createBaseDirectory() {
        do {
            try fileManager.createDirectory(at: directoryURL,
                        withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            self.logger?.logError(error, withMessage: "Cache can't create base directory.")
        }
    }
    
    /** Removes all cached files. */
    func clearCache() {
        privateQueue.addOperation {
            self.cache.removeAllObjects()
            do {
                try self.fileManager.removeItem(at: self.directoryURL)
                self.createBaseDirectory()
            } catch let error as NSError {
                self.logger?.logError(error, withMessage: "Cache can't remove base directory.")
            } catch {
            }
        }
    }
    
    /** Removes expired files. In addition removes 1/4 of files if total size exceeds `maxDiskCacheSize`. */
    fileprivate func cleanupCache() {
        privateQueue.addOperation {
            let fileURLs = self.getFilesToRemove()
            fileURLs.forEach {
                _ = try? self.fileManager.removeItem(at: $0)
            }
        }
    }
    
    fileprivate func getFilesToRemove() -> [URL] {
        let expirationDate = Date(timeIntervalSinceNow: -self.cacheConfiguration.maxCacheAge)
        let properties = Set([URLResourceKey.contentModificationDateKey, URLResourceKey.totalFileAllocatedSizeKey])
        var cacheSize: UInt = 0
        var expiredFiles = [URL]()
        var validFiles = [URL]()
        let fileURLs = self.getCachedFileURLs()
        /** Searches for expired files and calculates total size. */
        fileURLs.forEach {
            (aFileURL) -> () in
            let values = try? aFileURL.resourceValues(forKeys: properties)
            if let values = values, let modificationDate = values.contentModificationDate {
                if (modificationDate as NSDate).laterDate(expirationDate) == modificationDate {
                    validFiles.append(aFileURL)
                    if let fileSize = values.totalFileAllocatedSize {
                        cacheSize += UInt(fileSize)
                    }
                } else {
                    expiredFiles.append(aFileURL)
                }
            }
        }
        
        if cacheSize > self.cacheConfiguration.maxDiskCacheSize {
            validFiles = self.sortFileURLByModificationDate(validFiles)
            /** Let's just remove 1/4 of all files. */
            validFiles.removeSubrange(0 ..< (validFiles.count / 4))
            expiredFiles += validFiles
        }
        return expiredFiles
    }
    
    fileprivate func getCachedFileURLs() -> [URL] {
        let properties = [URLResourceKey.contentModificationDateKey, URLResourceKey.totalFileAllocatedSizeKey]
        do {
            return try self.fileManager.contentsOfDirectory(at: self.directoryURL,
                includingPropertiesForKeys: properties, options: .skipsHiddenFiles)
        } catch let error as NSError {
            self.logger?.logError(error, withMessage: "Cache can't get properties of files in base directory.")
            return [URL]()
        }
    }
    
    fileprivate func sortFileURLByModificationDate(_ urls: [URL]) -> [URL] {
        return urls.sorted {
            (url1, url2) -> Bool in
            let dateKey = Set<URLResourceKey>([URLResourceKey.contentModificationDateKey])
            do {
                let values1 = try url1.resourceValues(forKeys: dateKey)
                let values2 = try url2.resourceValues(forKeys: dateKey)
                if let date1 = values1.contentModificationDate {
                    if let date2 = values2.contentModificationDate {
                        return date1.compare(date2) == .orderedAscending
                    }
                }
            } catch {
                return false
            }
            return false
        }
    }
    
}
