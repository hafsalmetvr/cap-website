
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
                url: "/user",
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
                url: "/user/register",
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
                url: "/user/passwordreset",
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
    $scope.init = function(user,role){
        $scope.user_id = user;
        $scope.role_id = role;
        $scope.show_popup = false;
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
            $scope.get_questionairs();
            $scope.get_mentors();
            //$scope.get_mentees();
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
            $scope.get_mentor_mentees();
        } else {
            $scope.user_type = "Mentee";
        }
    }
    $scope.get_questionairs = function(){
        $http.get("/user/saqlist").success(function(data)
        {
            $scope.questionairs = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }    
    $scope.show_menu = function(){
        $('#menu').css('display', 'block');
    }
    $scope.hide_menu = function(){
        $('#menu').css('display', 'none');
    }
        $scope.paginate_questionairs = function(){
        $scope.current_ques_page = 1;
        $scope.que_pages = $scope.ques_list.length / $scope.ques_page_interval;
        if($scope.qes_pages > parseInt($scope.qes_pages))
            $scope.qes_pages = parseInt($scope.qes_pages) + 1;
        $scope.visible_qes_list = $scope.qes_list.slice(0, $scope.qes_page_interval);
    }

    $scope.select_ques_page = function(ques_page) {
        var last_ques_page = ques_page - 1;
        var start = (last_ques_page * $scope.ques_page_interval) + 1;
        var end = $scope.ques_page_interval * ques_page;
        $scope.current_ques_page = ques_page;
        $scope.visible_ques_list = $scope.ques_list.slice(start, end);
    }
    
    $scope.get_mentors = function(){
        $http.get("/user/adminmentor").success(function(data)
        {
            $scope.mentors = data.data;
            $scope.mentees = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
   
    $scope.activate = function(mentor){
        params = {
            'mentor_id': mentor.id,
            'new_status': 1
        }
        $http({
            method: 'post',
            url: "/user/adminmentor",
            data: $.param(params),
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
            mentor.status = 'ACTIVE';
        }).error(function(data, success){
        }); 
    }

    $scope.de_activate = function(mentor){
        params = {
            'mentor_id': mentor.id,
            'new_status': 2
        }
        $http({
            method: 'post',
            url: "/user/adminmentor",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
            mentor.status = 'INACTIVE';
        }).error(function(data, success){
        }); 
    }

    $scope.get_mentor_mentees = function(){
        $http.get("/user/mentees").success(function(data)
        {
            $scope.mentees = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.get_mentees = function(){
        $http.get("/user/mentees").success(function(data)
        {
            $scope.mentees = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.assign = function(mentee){
        $scope.show_popup = true;
        $scope.selected_mentee = mentee;
    }
    $scope.assign_mentee_a_mentor = function(mentor){
        var mentee = $scope.selected_mentee;
        var mentor = mentor;
        $http.get("/user/mentees/assign/"+mentee.id+"/"+mentor.id).success(function(data)
        {
            $scope.mentee.status = 'ASSIGNED';
            $scope.show_popup = false;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    /*$scope.reassign = function(mentor){
        $http.get("/user/mentees/reassign/"+mentee.id+"/").success(function(data)
        {
            $scope.mentee.status = 'Unassigned';
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }*/

}

function MentorMenteeController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(mentor_id){
        $scope.mentor_id = mentor_id
        $scope.user_type = "Administrator";
        $scope.get_mentor_mentees();
    }

     $scope.get_mentor_mentees = function(){
        $http.get("/user/adminmentor/"+$scope.mentor_id).success(function(data)
        {
            $scope.mentees = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    
    $scope.delete_mentor_mentees = function(mentee){

        $http.delete("/user/adminmentor/"+mentee.id).success(function(data)

        {

            $scope.get_mentor_mentees();

        }).error(function(data, status)

        {
             console.log(data || "Request failed");

        });
    }
}

function QuestionairController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(questionair_id){
        $scope.user_id = $cookies.user_id;
        $scope.role_id = $cookies.role_id;
        $scope.questionair_id = questionair_id;
        if($scope.role_id == 1){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 2){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
        $scope.get_questions();
    }
    $scope.get_questions = function(){
        $http.get("/user/saqlist/"+$scope.questionair_id).success(function(data)
        {
            $scope.questions = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.show_menu = function(){
        $('#menu').css('display', 'block');
    }
    $scope.hide_menu = function(){
        $('#menu').css('display', 'none');
    }
    
}

function SettingsController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(){
        $scope.user_id = $cookies.user_id;
        $scope.role_id = $cookies.role_id;
        $scope.reminder_interval = '';
        if($scope.role_id == 1){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 2){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
    }
    $scope.validate_form = function(){
        if($scope.reminder_interval == ''){
            $scope.msg = "Please Select Reminder Interval";
            return false;
        } else {
            return true;
        }
    }
    $scope.save_settings = function(){
        if($scope.validate_form()){
            params = { 
                'reminder_interval': $scope.reminder_interval,
            } 
            $http({
                method: 'post',
                url: "/user/reminderfrequency",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.status == "success"){
                    $scope.msg = "Settings Saved Successfully";
                } else {
                    $scope.msg = "Some error occured";
                }
            }).error(function(data, success){
            });
        }
    }
    $scope.show_menu = function(){
        $('#menu').css('display', 'block');
    }
    $scope.hide_menu = function(){
        $('#menu').css('display', 'none');
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
        if($scope.role_id == 1){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 2){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
        $scope.msg = '';
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
                url: "/user/create",
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.status == "true"){
                    $scope.msg = "Account created Successfully";
                } else {
                    $scope.msg = data.message;
                }
            }).error(function(data, success){
            });
        }
    }
    $scope.show_menu = function(){
        $('#menu').css('display', 'block');
    }
    $scope.hide_menu = function(){
        $('#menu').css('display', 'none');
    }
}
