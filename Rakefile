# encoding: UTF-8

require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'tmpdir'

CLOBBER.include('pkg', 'VinesCloud.framework')

desc 'Build distributable packages'
task :build => :xcode do
  # create package task after framework compilation so it's included in FileList
  Rake::PackageTask.new('vines-cloud-ios', '0.1.0') do |pkg|
    pkg.package_files = FileList['LICENSE', 'README.md', 'Examples/**/*', 'VinesCloud/**/*', 'VinesCloud.framework/**/*']
    pkg.need_zip = true
  end
  Rake::Task['package'].invoke
end

desc 'Compile Xcode framework'
task :xcode do
  Dir.mktmpdir do |build|
    ios = File.expand_path('Release-iphoneos', build)
    sim = File.expand_path('Release-iphonesimulator', build)
    lib = 'VinesCloud.framework/VinesCloud'

    %w[iphoneos5.0 iphonesimulator5.0].each do |sdk|
      sh "xcodebuild -project VinesCloud/VinesCloud.xcodeproj -scheme VinesCloud -sdk #{sdk} SYMROOT=#{build}"
    end

    # create universal library for device and simulator
    sh "lipo -create #{ios}/#{lib} #{sim}/#{lib} -output #{ios}/#{lib}"
    sh "mv #{ios}/VinesCloud.framework ."
  end
end

task :default => [:clobber, :build]

