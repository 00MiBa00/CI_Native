//
//  ScreamAndRushBridge.swift
//  ScreamAndRush Module - UIKit Integration
//

import UIKit
import SwiftUI

public class ScreamAndRushBridge {
    
    public static func present(
        from viewController: UIViewController,
        config: ScreamAndRushConfig = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let screamAndRushView = ScreamAndRushMainView(config: config)
        let hostingController = UIHostingController(rootView: screamAndRushView)
        
        hostingController.modalPresentationStyle = .fullScreen
        
        viewController.present(hostingController, animated: animated, completion: completion)
    }

    public static func presentAsSheet(
        from viewController: UIViewController,
        config: ScreamAndRushConfig = .default,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let screamAndRushView = ScreamAndRushMainView(config: config)
        let hostingController = UIHostingController(rootView: screamAndRushView)
        
        if #available(iOS 15.0, *) {
            if let sheet = hostingController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        } else {
            hostingController.modalPresentationStyle = .pageSheet
        }
        
        viewController.present(hostingController, animated: animated, completion: completion)
    }
    
    @discardableResult
    public static func embed(
        in viewController: UIViewController,
        containerView: UIView,
        config: ScreamAndRushConfig = .default
    ) -> UIHostingController<ScreamAndRushMainView> {
        let screamAndRushView = ScreamAndRushMainView(config: config)
        let hostingController = UIHostingController(rootView: screamAndRushView)
        
        viewController.addChild(hostingController)
        containerView.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: viewController)
        
        return hostingController
    }
    
    public static func createViewController(
        config: ScreamAndRushConfig = .default
    ) -> UIViewController {
        let screamAndRushView = ScreamAndRushMainView(config: config)
        let hostingController = UIHostingController(rootView: screamAndRushView)
        hostingController.title = "Scream and Rush"
        return hostingController
    }
}
