require 'test_helper'
require 'json'

class PackagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    assert_difference 'Package.count',1 do
      assert_difference 'Drug.count',2 do
        post create_package_url,
            headers: { "Content-Type": "application/json" },
            params: @input_correct
      end
    end
    assert_equal "epinephrine", Drug.last.name
    assert_response :success
  end

  test "should list drug names belongs to package" do
    assert_difference 'Package.count',1 do
      assert_difference 'Drug.count',2 do
        post create_package_url,
             headers: { "Content-Type": "application/json" },
             params: @input_correct
      end
    end
    assert_equal "epinephrine", Drug.last.name
    package = Package.last
    assert_equal ["lidocaine", "epinephrine"],package.drug_names
    assert_response :success
  end

  test "should find expiration of package" do
    assert_difference 'Package.count',1 do
      assert_difference 'Drug.count',2 do
        post create_package_url,
             headers: { "Content-Type": "application/json" },
             params: @input_correct
      end
    end
    assert_equal "epinephrine", Drug.last.name
    package = Package.last
    assert_equal "2013/01/30",package.expiration.strftime('%Y/%m/%d')
    assert_response :success
  end

  test "should update expiration of package when changing drug expiration date" do
    post create_package_url,
       headers: { "Content-Type": "application/json" },
       params: @input_correct
    assert_equal "epinephrine", Drug.last.name
    package = Package.last
    assert_equal "2013/01/30",package.expiration.strftime('%Y/%m/%d')
    assert_response :success

    put update_package_url(id: package.id),
        headers: { "Content-Type": "application/json" },
        params: @input_update_expiration
    drug = Drug.where(name: "epinephrine",package_id: package.id).first
    assert_equal ["1911/11/11"],drug.expiration_dates
    assert_equal "1911/11/11",package.reload.expiration.strftime('%Y/%m/%d')
    assert_response :success
  end

  test "should validate the input before update the drug" do
    post create_package_url,
         headers: { "Content-Type": "application/json" },
         params: @input_correct
    assert_equal "epinephrine", Drug.last.name
    package = Package.last
    assert_equal "2013/01/30",package.expiration.strftime('%Y/%m/%d')
    assert_response :success

    put update_package_url(id: package.id),
        headers: { "Content-Type": "application/json" },
        params: @input_no_drug_name
    json_data = JSON.parse @response.body
    assert json_data["errors"].include? "Record Not Found"
    assert_response 422
  end

  test "should list all packages" do
    assert_difference 'Package.count',1 do
      post create_package_url,
           headers: { "Content-Type": "application/json" },
           params: @input_correct
    end
    assert_difference 'Package.count',0 do
      put update_package_url(id: Package.last.id),
          headers: { "Content-Type": "application/json" },
          params: @input_update_expiration
    end
    assert_difference 'Package.count',1 do
      post create_package_url,
           headers: { "Content-Type": "application/json" },
           params: @input_new_package
    end

    get get_packages_url,
         headers: { "Content-Type": "application/json" }

    assert_equal "tylenon", Drug.last.name
    assert_response :success
    json_data = JSON.parse @response.body
    assert_equal Package.first.id,json_data["package"].first["id"]
    assert_equal ["lidocaine", "epinephrine"], json_data["package"].first["drugs"]
    assert_equal "1911/11/11", json_data["package"].first["expiration"]

    assert_equal Package.last.id,json_data["package"].last["id"]
    assert_equal ["tylenon"], json_data["package"].last["drugs"]
    assert_equal "2018/05/18", json_data["package"].last["expiration"]

  end

  test "should not create when expiration date is blank" do
    assert_difference 'Package.count',0 do
      assert_difference 'Drug.count',0 do
        post create_package_url,
             headers: { "Content-Type": "application/json" },
             params: @input_blank_expiration_dates
      end
    end

    json_data = JSON.parse @response.body
    assert json_data["errors"].join.include? "expiration date can't be blank"
    assert_response 422
  end

  test "should not create drug when input has no drug name" do
    assert_difference 'Package.count',0 do
      assert_difference 'Drug.count',0 do
        post create_package_url,
             headers: { "Content-Type": "application/json" },
             params: @input_no_drug_name
      end
    end
    json_data = JSON.parse @response.body
    assert json_data["errors"].join.include? "Name can't be blank"
    assert_response 422
  end

  test "should not create package when date format is wrong" do
    assert_difference 'Package.count',0 do
      assert_difference 'Drug.count',0 do
        post create_package_url,
             headers: { "Content-Type": "application/json" },
             params: @input_wrong_date_format
      end
    end
    json_data = JSON.parse @response.body
    assert json_data["errors"].join.include? "expiration date format is invalid(lidocaine)"
    assert_response 422
  end

  def setup
    @input_blank_expiration_dates = {"package": {"drugs": [{"name": "Lidocaine","expiration_dates": ""}]}}.to_json
    @input_no_drug_name = {"package": {"drugs": [{"expiration_dates": "2013/10/11"}]}}.to_json
    @input_correct = {"package":{"drugs":[{"name":"Lidocaine","expiration_dates":["2013/10/11","2013/01/30"]},{"name":"Epinephrine","expiration_dates":["2014/10/11"]}]}}.to_json
    @input_update_expiration = {"package": {"drugs": [{"name": "Epinephrine", "expiration_dates": ["1911/11/11"]}]}}.to_json
    @input_new_package = {"package": {"drugs": [{"name": "Tylenon", "expiration_dates": ["2018/5/18"]}]}}.to_json
    @input_wrong_date_format = {"package":{"drugs":[{"name":"Lidocaine","expiration_dates":["2013/10/11","01/30/2020"]},{"name":"Epinephrine","expiration_dates":["2014/10/11"]}]}}.to_json
  end


end
