// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "NotificationTroubleshooter",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "NotificationTroubleshooter", targets: ["NotificationTroubleshooter"]),
  ],
  targets: [
    .target(
      name: "NotificationTroubleshooter",
      path: "NotificationTroubleshooter",
      sources: ["Classes"],
      resources: [
        .process("Assets"),
      ]
    ),
  ]
)
