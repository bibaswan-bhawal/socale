import UIKit
import Flutter
import FirebaseCore
import CoreData

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let flutterNativeChannel = FlutterMethodChannel(name: "com.socale.socale/ios",
                                                binaryMessenger: controller.binaryMessenger)
      flutterNativeChannel.setMethodCallHandler({[weak self]
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch (call.method) {
          case "getNotifications" :
              self?.getAllStoredNotifications(result: result)
          case "deleteNotifications":
              self?.deleteAllStoredNotification(result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
         }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func deleteAllStoredNotification(result: FlutterResult) {
        let persistentContainer = NSPersistentContainer(name: "NotificationModel")
        let storeURL = URL.storeURL(for: "group.socale.container", databaseName: "notifications")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        persistentContainer.loadPersistentStores { description, error in
                    if let error = error {
                        print("Unable to load persistent stores: \(error)")
                    }
                }

        let managedContext = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Notification")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            result(true)
        } catch {
            result(false)
        }
    }
    
    private func getAllStoredNotifications(result: FlutterResult) {
        var notifications: [NSManagedObject] = []
        
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

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Notification")
        do {
            notifications = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("terminated notifications count in IOS \(notifications.count)")
        
        var notificationData: [String] = []
        
        notifications.forEach{ notification in
            notificationData.append(notification.value(forKeyPath: "data") as! String)
        }
        
        result(notificationData)
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
