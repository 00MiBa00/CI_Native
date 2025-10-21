# UIKit Integration для Scream and Rush

Эта папка содержит всё необходимое для интеграции модуля Scream and Rush в ваше UIKit приложение.

## 📁 Файлы

### 🔑 Основной файл
- **ScreamAndRushBridge.swift** - Bridge класс для интеграции SwiftUI модуля в UIKit

### 📚 Примеры и документация
- **ExampleViewController.swift** - Примеры различных способов использования
- **RealWorldExample.swift** - Реальные примеры интеграции в production приложение
- **UIKitIntegrationGuide.swift** - Подробное руководство со всеми сценариями

## 🚀 Быстрый старт

### Минимальный код для интеграции:

```swift
import UIKit

class MyViewController: UIViewController {
    
    @objc func openNoiseModule() {
        ScreamAndRushBridge.present(from: self)
    }
}
```

**Вот и всё!** Одна строка кода - и модуль работает.

## 🎯 Все доступные методы

### 1. Present (полноэкранный режим)
```swift
ScreamAndRushBridge.present(from: self)
```

### 2. Present as Sheet (модальное окно)
```swift
ScreamAndRushBridge.presentAsSheet(from: self)
```

### 3. Embed (встраивание в контейнер)
```swift
ScreamAndRushBridge.embed(
    in: self,
    containerView: myContainerView
)
```

### 4. Create ViewController (для навигации)
```swift
let vc = ScreamAndRushBridge.createViewController()
navigationController?.pushViewController(vc, animated: true)
```

## 💡 Примеры использования

### Из UIButton
```swift
button.addTarget(self, action: #selector(openModule), for: .touchUpInside)

@objc func openModule() {
    ScreamAndRushBridge.present(from: self)
}
```

### Из UIBarButtonItem
```swift
let barButton = UIBarButtonItem(
    title: "Шум",
    style: .plain,
    target: self,
    action: #selector(openModule)
)
navigationItem.rightBarButtonItem = barButton
```

### Из UITableView
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    ScreamAndRushBridge.present(from: self)
}
```

### С кастомной конфигурацией
```swift
let config = ScreamAndRushConfig(
    measurementDuration: 10.0,
    quietThreshold: 35.0,
    moderateThreshold: 65.0
)

ScreamAndRushBridge.present(from: self, config: config)
```

## 📖 Документация

- Начните с **RealWorldExample.swift** - там показаны реальные сценарии
- **UIKitIntegrationGuide.swift** - полное руководство со всеми деталями
- **ExampleViewController.swift** - готовые примеры кода

## ✅ Чек-лист интеграции

- [ ] Скопировали папку ScreamAndRush в проект
- [ ] Добавили разрешения в Info.plist
- [ ] Импортировали UIKit
- [ ] Добавили вызов `ScreamAndRushBridge.present(from: self)`
- [ ] Готово! 🎉

## 🎨 Кастомизация

### Изменить длительность измерения
```swift
let config = ScreamAndRushConfig(measurementDuration: 10.0)
ScreamAndRushBridge.present(from: self, config: config)
```

### Изменить пороги шума
```swift
let config = ScreamAndRushConfig(
    quietThreshold: 35.0,
    moderateThreshold: 65.0
)
ScreamAndRushBridge.present(from: self, config: config)
```

### Отключить экспорт/историю
```swift
let config = ScreamAndRushConfig(
    enableExport: false,
    enableHistory: false
)
ScreamAndRushBridge.present(from: self, config: config)
```

## 🔧 Требования

- iOS 16.0+
- Swift 5.9+
- UIKit приложение
- Разрешения микрофона и геолокации в Info.plist

## 💬 Поддержка

Если что-то не работает:
1. Проверьте разрешения в Info.plist
2. Убедитесь что iOS 16.0+
3. Проверьте что ScreamAndRushBridge.swift добавлен в проект
4. Посмотрите примеры в RealWorldExample.swift

---

**Приятного использования! 🪶**
