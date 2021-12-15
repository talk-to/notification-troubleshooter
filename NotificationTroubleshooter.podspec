Pod::Spec.new do |s|
  s.name             = 'NotificationTroubleshooter'
  s.version          = '0.1.2'
  s.summary          = 'Cocoapod to troubleshoot push notifications in iOS.'

  s.description      = <<-DESC
Cocoapod to troubleshoot push notifications in iOS and if there are any syncing issues
with the server, it corrects it.
                       DESC

  s.homepage         = 'https://github.com/talk-to/notification-troubleshooter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aditya Ghosh' => 'adityaghosh96@gmail.com' }
  s.source           = { :git => 'https://github.com/talk-to/notification-troubleshooter.git', :tag => s.version.to_s }
  s.swift_version = '4.0'
  s.ios.deployment_target = '11.0'
  s.source_files = 'NotificationTroubleshooter/Classes/**/*'
  
  s.resource_bundles = {
    'NotificationTroubleshooter' => ['NotificationTroubleshooter/Assets/*.*']
  }

end
