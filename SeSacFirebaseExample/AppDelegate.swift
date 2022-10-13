//
//  AppDelegate.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/05.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 마이그레이션
        aboutRealmMigration()
        
        
        // 메서드 스위즐링
        UIViewController.swizzleMethod()
        
        
        // Firebase 등록
        FirebaseApp.configure()
        
        
        // 알림 시스템에 앱을 등록하는 과정
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        // APNs 등록
        application.registerForRemoteNotifications()
                
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        
        // 현재 등록된 토큰 가져오기
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}



// MARK: - 마이그레이션
extension AppDelegate {
    
    func aboutRealmMigration() {
        
        // deleteRealmIfMigrationNeeded: 마이그레이션이 필요한 경우 기존 렘 삭제
        // Realm Browser 닫고 다시 열기!!
//        let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
//
//        Realm.Configuration.defaultConfiguration = config
        
        
        
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            // 컬럼의 단순 추가/삭제의 경우엔 별도 코드 필요 없음!
            // 테이블이 추가되는 경우에도!!
            if oldSchemaVersion < 1 { }
            
            if oldSchemaVersion < 2 { }
            
            if oldSchemaVersion < 3 {
                migration.renameProperty(onType: Todo.className(), from: "importance", to: "favorite")
            }
            
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["userDescription"] = "\(old["title"])의 중요도 : \(old["favorite"])"
                }
            }
            
            if oldSchemaVersion < 5 {
                // 컬럼을 추가하면서 기본값을 제공하는 목적으로도 사용할 수 있다.
                migration.enumerateObjects(ofType: Todo.className()) { _, newObject in
                    guard let new = newObject else { return }
                    
                    new["count"] = 100
                }
            }
            
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    // Int => Double 타입변환은 반드시 성공하기 때문에, 형변환 코드를 작성하지 않아도 괜춘!
                    new["favorite"] = old["favorite"]
                    
                    // 만약 Optional Type => non Optional Type으로 변환이라면?
                    // 형변환 코드와 기본값을 제공하는 코드가 필요!
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
    
}




// MARK: - UNUserNotificationCenterDelegate 프로토콜 채택
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Remote Notification이 등록되면 호출
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // 포그라운드 알림 수신: 로컬/푸시 동일
    // ex카톡: OO님과 채팅방, 푸시마다 설정, 화면마다 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 특정 화면에서는 푸시를 보내지 마라! (라는 분기처리도 가능)
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is SettingViewController {
            // return하거나, 특정 요소만 받도록 분거처리도 가능
            completionHandler([.badge])
            
        }else {
            // .banner, .list: iOS 14+
            completionHandler([.badge, .sound, .banner, .list])
        }
        
    }
    
    
    // 푸시 클릭: ex. 호두과자 장바구니에 담는 화면까지 넘어가는...
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능 (잘 보내졌는지? 확인하는건 불가능)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Body: \(response.notification.request.content.body)")
        print("userInfo: \(response.notification.request.content.userInfo)")
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SESAC PROJECT")
        }else {
            print("NOTHING")
        }
        
        
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is ViewController {
            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
            
        }else if viewController is ProfileViewController {
            viewController.dismiss(animated: true)
            
        }else if viewController is SettingViewController {
            viewController.navigationController?.popViewController(animated: true)
        }
        
        print(viewController)
    }
}




// MARK: - MessagingDelegate 프로토콜 채택
extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링 : 토큰 정보가 언제 바뀔까?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
