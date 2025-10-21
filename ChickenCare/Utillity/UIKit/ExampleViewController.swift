//
//  ExampleViewController.swift
//  ScreamAndRush Module - UIKit Examples
//

import UIKit

/// Пример использования модуля Scream and Rush из UIKit ViewController
class ExampleViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Моё UIKit приложение"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let presentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Открыть Scream and Rush (Full Screen)", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Открыть как Sheet", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let embedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Встроить в контейнер", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pushButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Push в Navigation", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let customConfigButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("С кастомной конфигурацией", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(presentButton)
        view.addSubview(sheetButton)
        view.addSubview(embedButton)
        view.addSubview(pushButton)
        view.addSubview(customConfigButton)
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Present Button
            presentButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            presentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            presentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            presentButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Sheet Button
            sheetButton.topAnchor.constraint(equalTo: presentButton.bottomAnchor, constant: 15),
            sheetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sheetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Embed Button
            embedButton.topAnchor.constraint(equalTo: sheetButton.bottomAnchor, constant: 15),
            embedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            embedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            embedButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Push Button
            pushButton.topAnchor.constraint(equalTo: embedButton.bottomAnchor, constant: 15),
            pushButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pushButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pushButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Custom Config Button
            customConfigButton.topAnchor.constraint(equalTo: pushButton.bottomAnchor, constant: 15),
            customConfigButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customConfigButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customConfigButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupActions() {
        presentButton.addTarget(self, action: #selector(presentFullScreen), for: .touchUpInside)
        sheetButton.addTarget(self, action: #selector(presentSheet), for: .touchUpInside)
        embedButton.addTarget(self, action: #selector(embedInContainer), for: .touchUpInside)
        pushButton.addTarget(self, action: #selector(pushToNavigation), for: .touchUpInside)
        customConfigButton.addTarget(self, action: #selector(presentWithCustomConfig), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    /// Способ 1: Открыть в полноэкранном режиме
    @objc private func presentFullScreen() {
        ScreamAndRushBridge.present(from: self)
    }
    
    /// Способ 2: Открыть как Sheet (модальное окно)
    @objc private func presentSheet() {
        ScreamAndRushBridge.presentAsSheet(from: self)
    }
    
    /// Способ 3: Встроить в контейнер
    @objc private func embedInContainer() {
        let containerVC = ContainerViewController()
        navigationController?.pushViewController(containerVC, animated: true)
    }
    
    /// Способ 4: Push в Navigation Controller
    @objc private func pushToNavigation() {
        let screamAndRushVC = ScreamAndRushBridge.createViewController()
        navigationController?.pushViewController(screamAndRushVC, animated: true)
    }
    
    /// Способ 5: С кастомной конфигурацией
    @objc private func presentWithCustomConfig() {
        let config = ScreamAndRushConfig(
            measurementDuration: 10.0,
            quietThreshold: 35.0,
            moderateThreshold: 65.0,
            enableARMode: false,
            enableExport: true,
            enableHistory: true
        )
        
        ScreamAndRushBridge.present(from: self, config: config)
    }
}

// MARK: - Container ViewController Example

/// Пример контроллера со встроенным модулем
class ContainerViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Встроенный модуль"
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Встраиваем модуль
        ScreamAndRushBridge.embed(in: self, containerView: containerView)
    }
}

// MARK: - SceneDelegate / AppDelegate Integration

/*
 
 // В SceneDelegate.swift или AppDelegate.swift:
 
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     guard let windowScene = (scene as? UIWindowScene) else { return }
     
     let window = UIWindow(windowScene: windowScene)
     
     // Создаем root view controller
     let rootVC = ExampleViewController()
     let navigationController = UINavigationController(rootViewController: rootVC)
     
     window.rootViewController = navigationController
     self.window = window
     window.makeKeyAndVisible()
 }
 
 */
