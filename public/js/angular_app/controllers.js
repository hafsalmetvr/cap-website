
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
                url: "http://localhost/Cap/public/auth",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.login == "true"){
                    $scope.msg = "Successfully logged in";
                    $cookies.user_id = data.uid;
                    $cookies.role_id = data.role_id;
                    document.location.href = "/Cap/public/dashboard.html";
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
    $scope.init = function(){
        console.log('hai');
        $scope.email = '';
        $scope.old_password = '';
        $scope.new_password = '';
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
        console.log('clciked-------');
        $scope.is_valid = $scope.validate_form();
        if ($scope.is_valid) {
            params = { 
                'email': $scope.email,
            } 
            $http({
                method: 'post',
                url: "http://localhost/Cap/public/user/register/",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.data == "sent"){
                    $scope.msg = "Your request sent Successfully, Please check your email";
                } else {
                    $scope.msg = "Some error occured";
                }
            }).error(function(data, success){
            });
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
