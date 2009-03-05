module MockScopeHelper

  def mock_scope(arr, *expectations)
    expectations.each { |e| arr.stub!(e).and_return(arr)}
    arr
  end

end
