Pod::Spec.new do |s|
  s.name         = "MrCoinSDK"
  s.version      = "0.0.1"
  s.summary      = "MrCoin SDK for iOS"

  s.description  = <<-DESC
                   A longer description of mrcoin-sdk-ios in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/MrCoin/mrcoin-sdk-ios"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author             = { "MrCoin" => "email@address.com" }
  # s.social_media_url   = "http://twitter.com/MrCoin"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/MrCoin/mrcoin-sdk-ios.git", :commit => "326b3e3" }
  s.source_files  = "framework/Source", "framework/Source/**/*.{h,m}"
  s.resources = "framework/Resources/**/*.{png,storyboard,strings}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
