def webmock_stub
  stub_request(:get, "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_86.0.4240").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'chromedriver.storage.googleapis.com',
              'User-Agent'=>'Ruby'
          }).
      to_return(status: 200, body: "", headers: {})

  stub_request(:put, "http://169.254.169.254/latest/api/token").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'aws-sdk-ruby3/3.96.1',
              'X-Aws-Ec2-Metadata-Token-Ttl-Seconds'=>'21600'
          }).
      to_return(status: 200, body: "", headers: {})

  stub_request(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'aws-sdk-ruby3/3.96.1'
          }).
      to_return(status: 200, body: "", headers: {})

  stub_request(:get, "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_86.0.4240").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'chromedriver.storage.googleapis.com',
              'User-Agent'=>'Ruby'
          }).
      to_return(status: 200, body: "", headers: {})
end


