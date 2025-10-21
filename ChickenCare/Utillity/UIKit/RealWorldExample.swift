//
//  RealWorldExample.swift
//  ScreamAndRush Module - Real World UIKit Example
//

import UIKit


class MainViewController: UIViewController {
    
    // Ваш существующий UI
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Добавьте кнопку для открытия модуля
    private let noiseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🪶 Measure the noise level", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        // Добавьте target для кнопки - ЭТО ВСЁ ЧТО НУЖНО!
        noiseButton.addTarget(self, action: #selector(openNoiseModule), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(noiseButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            noiseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noiseButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            noiseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            noiseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            noiseButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // ЕДИНСТВЕННЫЙ метод который нужно добавить:
    @objc private func openNoiseModule() {
        ScreamAndRushBridge.present(from: self)
    }
}

// MARK: - 2. Settings ViewController (пример в настройках)

class SettingsViewController: UITableViewController {
    
    private let sections = [
        ["Profile", "Notifications"],
        ["Noise measurement", "Measurement history"],  // ← Добавили новые опции
        ["About the app", "Exit"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Обработка нажатия на "Измерение шума"
        if indexPath.section == 1 && indexPath.row == 0 {
            ScreamAndRushBridge.present(from: self)
        }
        // Обработка нажатия на "История замеров"
        else if indexPath.section == 1 && indexPath.row == 1 {
            // Открываем сразу на экране истории
            let config = ScreamAndRushConfig(enableHistory: true)
            ScreamAndRushBridge.present(from: self, config: config)
        }
    }
}

// MARK: - 3. Dashboard ViewController (пример интеграции в dashboard)

class DashboardViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        view.backgroundColor = .systemBackground
        
        setupUI()
        addDashboardCards()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func addDashboardCards() {
        // Существующие карточки
        contentStack.addArrangedSubview(createCard(title: "Statistics", icon: "chart.bar.fill"))
        contentStack.addArrangedSubview(createCard(title: "Activity", icon: "flame.fill"))
        
        // Новая карточка для измерения шума
        let noiseCard = createCard(title: "Noise level", icon: "waveform")
        noiseCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNoiseModule)))
        contentStack.addArrangedSubview(noiseCard)
        
        contentStack.addArrangedSubview(createCard(title: "Settings", icon: "gearshape.fill"))
    }
    
    private func createCard(title: String, icon: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(label)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 100),
            
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        return card
    }
    
    @objc private func openNoiseModule() {
        ScreamAndRushBridge.present(from: self)
    }
}

// MARK: - 4. Tab Bar Controller Setup

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        // Существующие вкладки
        let homeVC = UINavigationController(rootViewController: MainViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let dashboardVC = UINavigationController(rootViewController: DashboardViewController())
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.bar"), tag: 1)
        
        // Новая вкладка с модулем шума (опционально)
        let noiseVC = ScreamAndRushBridge.createViewController()
        let noiseNavVC = UINavigationController(rootViewController: noiseVC)
        noiseNavVC.tabBarItem = UITabBarItem(
            title: "Noise",
            image: UIImage(systemName: "waveform"),
            tag: 2
        )
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 3)
        
        viewControllers = [homeVC, dashboardVC, noiseNavVC, settingsVC]
    }
}

// MARK: - 5. SceneDelegate Setup

/*
 
 В вашем SceneDelegate.swift:
 
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions) {
     guard let windowScene = (scene as? UIWindowScene) else { return }
     
     let window = UIWindow(windowScene: windowScene)
     window.rootViewController = AppTabBarController()
     self.window = window
     window.makeKeyAndVisible()
 }
 
 */

// MARK: - 6. AppDelegate Setup (для старых проектов)

/*
 
 В вашем AppDelegate.swift:
 
 func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
     window = UIWindow(frame: UIScreen.main.bounds)
     window?.rootViewController = AppTabBarController()
     window?.makeKeyAndVisible()
     
     return true
 }
 
 */

// MARK: - 7. Использование с UIButton в Storyboard

/*
 
 Если вы используете Storyboard:
 
 1. Создайте кнопку в Interface Builder
 2. Создайте IBAction:
 
 @IBAction func measureNoiseButtonTapped(_ sender: UIButton) {
     ScreamAndRushBridge.present(from: self)
 }
 
 3. Подключите кнопку к IBAction в Storyboard
 
 */

// MARK: - 8. Использование с UIBarButtonItem

extension UIViewController {
    
    func addNoiseBarButton() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "waveform"),
            style: .plain,
            target: self,
            action: #selector(openNoiseModuleFromBarButton)
        )
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func openNoiseModuleFromBarButton() {
        ScreamAndRushBridge.present(from: self)
    }
}

// Использование:
// override func viewDidLoad() {
//     super.viewDidLoad()
//     addNoiseBarButton()
// }

// MARK: - Итого

/*
 
 ════════════════════════════════════════════════════════════════
 РЕЗЮМЕ: ЧТО НУЖНО СДЕЛАТЬ
 ════════════════════════════════════════════════════════════════
 
 1. Скопировать папку ScreamAndRush в проект ✓
 2. Добавить ключи в Info.plist ✓
 3. В любом ViewController добавить:
 
    @objc func openModule() {
        ScreamAndRushBridge.present(from: self)
    }
 
 4. Готово! 🎉
 
 ════════════════════════════════════════════════════════════════
 
 */
