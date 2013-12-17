Pod::Spec.new do |s|
  s.name = 'ObjectiveTumblr'
  s.version = '0.2.0'
  s.license = { :type => 'MIT', :text => <<-LICENSE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
LICENSE
  }
  s.summary = 'Tumblr API Client for Objective-C with minimal features, based on Tumblr API v2 (OAuth).'
  s.homepage = 'https://github.com/IgnitionSoft/ObjectiveTumblr'
  s.authors = { 'Francis Chong' => 'francis@ignition.hk' }
  s.source = { :git => 'https://github.com/IgnitionSoft/ObjectiveTumblr.git', :commit => '716260f' }
  s.source_files = 'ObjectiveTumblr/Classes/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'

  s.dependency 'RSOAuthEngine'
  s.dependency 'JTObjectMapping'
end