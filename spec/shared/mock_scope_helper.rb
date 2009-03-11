module MockScopeHelper

  def mock_scope(arr, *expectations)
    expectations.each { |e| arr.should_receive(e).at_least(:once).and_return(arr)}
    arr
  end

end
