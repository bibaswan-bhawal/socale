//
//  NotificationService.swift
//  notificationDataReceiver
//
//  Created by Bibaswan Bhawal on 11/15/22.
//

import UserNotifications
import FirebaseMessaging
import CoreData

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        let persistentContainer = NSPersistentContainer(name: "NotificationModel")
        let storeURL = URL.storeURL(for: "group.socale.container", databaseName: "notifications")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        
        persistentContainer.loadPersistentStores { description, error in
                    if let error = error {
                        fatalError("Unable to load persistent stores: \(error)")
                    }
                }
        
        let managedContext = persistentContainer.viewContext
                
        if let bestAttemptContent = bestAttemptContent {
            let userInfo = bestAttemptContent.userInfo as! [String: Any]
            
            let entity =
                NSEntityDescription.entity(forEntityName: "Notification",
                                           in: managedContext)!
            
            let notification = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
            
            if userInfo["message"] != nil {
                notification.setValue(userInfo["message"], forKeyPath: "data")
                
                do {
                    try managedContext.save()
                    bestAttemptContent.body = "saved to db successfully"
                  } catch let error as NSError {
                      bestAttemptContent.body = "Error saving db: \(error)"
                  }
            }
            
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            FIRMessagingExtensionHelper().populateNotificationContent(bestAttemptContent, withContentHandler: contentHandler)
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

