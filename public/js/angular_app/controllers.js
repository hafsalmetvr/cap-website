
function validateEmail(email) { 
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}


function LoginController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(){
        $scope.email = '';
        $scope.password = '';
    }
    $scope.validate_login_form = function(){
        if($scope.email == ''){
            $scope.msg = "Please enter username";
            return false;
        } else if($scope.password == ''){
            $scope.msg = "Please enter password";
            return false;
        } else if(!validateEmail($scope.email)){
            $scope.msg = "Please enter a valid email address";
            return false;
        } else {
            $scope.msg = '';
            return true;
        }
    }
    $scope.submit_login = function(){
        $scope.is_valid = $scope.validate_login_form();
        if ($scope.is_valid) {
            params = { 
                'email': $scope.email,
                'password': $scope.password, 
            } 
            $http({
                method: 'post',
                url: "/Cap/public/user",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.login == "true"){
                    $scope.msg = "Successfully logged in";
                    $cookies.user_id = data.uid;
                    $cookies.role_id = data.role_id;
                    document.location.href = "./dashboard";
                } else {
                    $scope.msg = "Username or password is incorrect";
                }
            }).error(function(data, success){
            });
        }   
    }
}


function ForgotPasswordController($scope, $element, $http, $timeout, $location)
{
    $scope.init = function(token){
        $scope.email = '';
        $scope.old_password = '';
        $scope.new_password = '';
        $scope.token_value = token;

    }
    $scope.validate_form = function(){
        if($scope.email == ''){
            $scope.msg = "Please enter username";
            return false;
        } else if(!validateEmail($scope.email)){
            $scope.msg = "Please enter a valid email address";
            return false;
        } else {
            $scope.msg = '';
            return true;
        }
    }
    $scope.validate_password= function(){
        if($scope.old_password == ''){
            $scope.msg = "Please enter old password";
            return false;
        } else if($scope.new_password == ''){
            $scope.msg = "Please enter new password";
            return false;
        } else {
            $scope.msg = '';
            return true;
        }
    }
    $scope.forgot_password = function(){
        $scope.is_valid = $scope.validate_form();
        if ($scope.is_valid) {
            params = { 
                'email': $scope.email,
            } 
            $http({
                method: 'post',
                url: "/Cap/public/user/register",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.status == "sent"){
                    $scope.msg = "Your request sent Successfully, Please check your email";
                } else {
                    $scope.msg = "Some error occured";
                }
            }).error(function(data, success){
            });
        }   
    }
   
    $scope.change_password = function(){
        console.log($scope.token_value);
        if ($scope.new_password != '' && $scope.confirm_password != '') {
            params = { 
                'new_password': $scope.new_password,
                'confirm_password': $scope.confirm_password,
                'token': $scope.token_value
            } 
            $http({
                method: 'post',
                url: "/Cap/public/user/passwordreset",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.passwordreset == "success"){
                    $scope.msg = "Password changed successfully";
                    document.location.href = "../../login";
                } else {
                    $scope.msg = "Some error occured";
                }
            }).error(function(data, success){

            });
        } else {
            $scope.msg = "Please Enter Old password and New Password";
        }  
    }
    

}



function DashboardController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(){
        $scope.user_id = $cookies.user_id;
        $scope.role_id = $cookies.role_id;
        console.log($scope.user_id, $scope.role_id);
    }
}

function CreateAccountController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(){
        $scope.user_id = $cookies.user_id;
        $scope.role_id = $cookies.role_id;
        $scope.account_type = '';
        $scope.name = '';
        $scope.title = '';
        $scope.phone_number = '';
        $scope.email = '';
    }
    $scope.validate_form = function(){
        if($scope.account_type == ''){
            $scope.msg = "Please Select Account Type";
            return false;
        } else if($scope.name == ''){
            $scope.msg = "Please Enter name";
            return false;
        } else if($scope.title == ''){
            $scope.msg = "Please enter Title";
            return false;
        } else if($scope.phone_number == ''){
            $scope.msg = "Please Enter phone number";
            return false;
        } else if(!validateEmail($scope.email)) {
            $scope.msg = "Please enter a valid email address";
            return false
        } else {
            return true;
        }
    }
    $scope.create_account = function(){
        if($scope.validate_form()){
            params = { 
                'account_type': $scope.account_type,
                'name': $scope.name,
                'title': $scope.title,
                'phone_number': $scope.phone_number,
                'email': $scope.email,
            } 
            $http({
                method: 'post',
                url: "/Cap/public/user/register/",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.data == "sent"){
                    $scope.msg = "Account created Successfully";
                } else {
                    $scope.msg = "Some error occured";
                }
            }).error(function(data, success){
            });
        }
    }
}
