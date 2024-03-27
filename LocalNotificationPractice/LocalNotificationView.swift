//
//  ContentView.swift
//  LocalNotificationPractice
//
//  Created by Wataru Miyakoshi on 2024/03/27.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        print(#function)
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification!"
        content.subtitle = "This was soooo easy!"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 11
//        dateComponents.minute = 4
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func resetBadgeNumber() {
        Task {
            do {
                try await UNUserNotificationCenter.current().setBadgeCount(0)
            } catch {
                print(error)
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

struct LocalNotificationView: View {
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                NotificationManager.shared.requestAuthorization()
            }, label: {
                Text("Request permission")
            })
            Button(action: {
                NotificationManager.shared.scheduleNotification()
            }, label: {
                Text("Schedule notification")
            })
            Button(action: {
                NotificationManager.shared.cancelNotification()
            }, label: {
                Text("Cancel notifications")
            })
        }
        .padding()
        .onAppear(perform: {
            NotificationManager.shared.resetBadgeNumber()
        })
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                print()
            }
        }
    }
}

#Preview {
    LocalNotificationView()
}
