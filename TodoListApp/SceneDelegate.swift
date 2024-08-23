//
//  SceneDelegate.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: TodayTodoViewController())
        let vc2 = UINavigationController(rootViewController: CalendarTodoViewController())
        let vc3 = UINavigationController(rootViewController: AllTodoListViewController())
        
        
//        vc1.navigationBar.topItem?.titleView?.largeContentImage = UIImage(named: "mainNaviIcon")
        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .clear
        //아이템 선택시 컬러
        tabBarVC.tabBar.unselectedItemTintColor = .black
        tabBarVC.tabBar.layer.shadowColor = UIColor.blue.cgColor
        
        
        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "checkmark.square")
        //        items[0].selectedImage = UIImage(named: "mainSelectedIcon")
        items[1].image = UIImage(systemName: "calendar")
        //        items[1].selectedImage = UIImage(named: "searchSelectedIcon")
        items[2].image = UIImage(systemName: "list.dash")
//        items[3].image = UIImage(systemName: "magnifyingglass")
        
        tabBarVC.modalTransitionStyle = .crossDissolve
        tabBarVC.modalPresentationStyle = .fullScreen
        
        //        present(tabBarVC, animated: true, completion: nil)
        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        //        let naviVC = UINavigationController(rootViewController: TodayTodoViewController())
        //
        //        window?.rootViewController = naviVC
        //        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    // 앱이 비활성화 상태로 전환되기 직전에 호출됨
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).

    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        ///

    }
    
    // 앱이 백그라운드로 전환될 때 호출됨
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }
    
}

//사용자가 탭바 클릭시 호출
//extension SceneDelegate: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//        if let navController = viewController as? UINavigationController,
//           let allTodoListViewController = navController.viewControllers.last as? AllTodoListViewController {
//            allTodoListViewController.scrollPosition()
//        }
//
//    }
//}
