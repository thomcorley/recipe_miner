# frozen_string_literal: true

module StubRequestSpecHelper
  # rubocop:disable Layout/AlignHash, Layout/IndentHash
  def stub_200_response_for(url)
    stub_request(:get, url).
      with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: "", headers: {})
  end

  # rubocop:disable Layout/AlignHash, Layout/IndentHash
  def stub_response_for(url:, body:)
    stub_request(:get, url).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: body, headers: {})
  end

  def grubdaily_url
    "https://www.grubdaily.com"
  end

  def grubdaily_sitemap_url
    "https://www.grubdaily_url/sitemap.xml"
  end

  def stub_get_request_with(response)
    allow_any_instance_of(HttpRequest::Get).to receive(:body).and_return(response)
  end
end
