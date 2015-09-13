Pod::Spec.new do |s|
  s.name             = "Statistics"
  s.version          = "0.1.0"
  s.summary          = "Statistics class for Objective-C."

  s.description      = <<-DESC
  Statistics is a Foundation framework for calculating—no points for guessing it—statistics. It is inspired by Perl's Statistics::Descriptive and like it consists of two main classes.

  SBStatistics calculates a range of statistical measurements on the fly as each data point is added. The data is then immediately discarded, giving it a very low memory footprint.

  SBFullStatistics in turn subclasses SBStatistics and records each data point. It is therefore able to provide more advanced statistical functions. The trade-off is that it can consume a lot of memory if you are collecting a lot of data.
                       DESC

  s.homepage         = "https://github.com/stig/Statistics"
  s.license          = 'MIT'
  s.author           = { "Stig Brautaset" => "stig@brautaset.org" }
  s.source           = { :git => "https://github.com/stig/Statistics.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stigbra'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'

end
