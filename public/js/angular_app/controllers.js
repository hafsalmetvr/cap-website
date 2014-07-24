
function validateEmail(email) { 
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}

function save_new_note($scope, $http){
    console.log(validate_note($scope));
    if(validate_note($scope)){
        params = { 
            'title': $scope.current_note.title,
            'created': 'dummy txt',
            'id': $scope.current_note.id,
            'share_with_mentee': $scope.current_note.share_with_mentee,
            'mentee' :$scope.mentee_id,
        } 
        if($scope.edit_flag){
            var url = "/user/notes/"+$scope.current_note.id;
            $http({
            method: 'put',
                url: url,
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.status == "true"){
                    $scope.msg = "Note saved Successfully";
                } else {
                    $scope.msg = data.message;
                }
                $scope.get_notes();
                $scope.msg = '';
                $scope.edit_flag = false;
                $scope.show_popup = false;
                $scope.clear_current_note();
            }).error(function(data, success){
            });
        } else {
            var url = "/user/notes/"
            $http({
            method: 'post',
                url: url,
                data: angular.toJson(params),
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(function(data, status) {
                if(data.status == "true"){
                    $scope.msg = "Note saved Successfully";
                } else {
                    $scope.msg = data.message;
                }
                $scope.get_notes();
                $scope.msg = '';
                $scope.edit_flag = false;
                $scope.show_popup = false;
                $scope.clear_current_note();
            }).error(function(data, success){
            });
        }

    }
}
function delete_note(note, $scope, $http){

    $http.delete("/user/notes/"+note.id).success(function(data)
    {
        $scope.get_notes();
    }).error(function(data, status)
    {
         console.log(data || "Request failed");
    });
}
function edit_note(note, $scope){
    $scope.edit_flag = true;
    $scope.msg = false;
    $scope.show_popup = true;
    $scope.current_note.title = note.title;
    $scope.current_note.id = note.id;
    $scope.current_note.description = note.description;
}
function validate_note($scope){
    if($scope.current_note.title == ''){
        $scope.msg = "Please Enter Title";
        return false;
    } else {
        return true;
    }
    return true;
}
function clear_current_note($scope){
    $scope.current_note.title = '';
    $scope.current_note.id = '';
    $scope.current_note.share_with_mentee = false;
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
        $scope.ques_page_interval = 5;
        $scope.mentor_page_interval = 5;
        $scope.mentee_page_interval = 5;
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
            $scope.get_questionairs();
            $scope.get_mentors();
            $scope.get_mentees();
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
            $scope.get_mentor_mentees();
        } else {
            $scope.user_type = "Mentee";
            $scope.get_mentee_saq_list();
            $scope.get_notes();
            $scope.edit_flag = false;
        }
    }
    $scope.range = function(n) {
        return new Array(n);
    }
    $scope.getClass = function(page) {
        if(page == $scope.current_page)
            return "current";
        else
            return '';
    }
    $scope.get_questionairs = function(){
        $http.get("/user/saqlist").success(function(data)
        {
            $scope.questionairs = data.data;
            $scope.paginate_questionairs();
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    } 
    $scope.get_mentee_saq_list = function(){
        $http.get("/user/adminmentee/"+$scope.user_id).success(function(data)
        {
            $scope.questionairs = data.data;
            $scope.paginate_questionairs();
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
        $scope.que_pages = $scope.questionairs.length / $scope.ques_page_interval;
        if($scope.que_pages > parseInt($scope.que_pages))
            $scope.que_pages = parseInt($scope.que_pages) + 1;
        $scope.visible_questionairs = $scope.questionairs.slice(0, $scope.ques_page_interval);
    }

    $scope.select_ques_page = function(ques_page) {
        if(ques_page == 0){
            ques_page = $scope.current_ques_page + 1;
        } else if(ques_page == -1){
            ques_page = $scope.current_ques_page - 1;
        }
        var last_ques_page = ques_page - 1;
        var start = (last_ques_page * $scope.ques_page_interval) ;
        var end = $scope.ques_page_interval * ques_page;
        $scope.current_ques_page = ques_page;
        $scope.visible_questionairs = $scope.questionairs.slice(start, end);
    }
    
    $scope.get_mentors = function(){
        $http.get("/user/adminmentor").success(function(data)
        {
            $scope.mentors = data.data;
            $scope.paginate_mentors();
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.paginate_mentors = function(){
        $scope.current_mentor_page = 1;
        $scope.mentor_pages = $scope.mentors.length / $scope.mentor_page_interval;
        if($scope.mentor_pages > parseInt($scope.mentor_pages))
            $scope.mentor_pages = parseInt($scope.mentor_pages) + 1;
        $scope.visible_mentors = $scope.mentors.slice(0, $scope.mentor_page_interval);
    }

    $scope.select_mentor_page = function(mentor_page) {
        if(mentor_page == 0){
            mentor_page = $scope.current_mentor_page + 1;
        } else if(mentor_page == -1){
            mentor_page = $scope.current_mentor_page - 1;
        }
        var last_mentor_page = mentor_page - 1;
        var start = (last_mentor_page * $scope.mentor_page_interval);
        var end = $scope.mentor_page_interval * mentor_page;
        $scope.current_mentor_page = mentor_page;
        $scope.visible_mentors = $scope.mentors.slice(start, end);
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
        $http.get("/user/adminmentor/"+$scope.user_id).success(function(data)
        {
            $scope.mentees = data.data;
            $scope.paginate_mentees();
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.get_mentees = function(){
        $http.get("/user/adminmentee").success(function(data)
        {
            $scope.mentees = data.data;
            $scope.paginate_mentees();

        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.paginate_mentees = function(){
        $scope.current_mentee_page = 1;
        $scope.mentee_pages = $scope.mentees.length / $scope.mentee_page_interval;
        if($scope.mentee_pages > parseInt($scope.mentee_pages))
            $scope.mentee_pages = parseInt($scope.mentee_pages) + 1;
        $scope.visible_mentees = $scope.mentees.slice(0, $scope.mentee_page_interval);
    }

    $scope.select_mentee_page = function(mentee_page) {
        if(mentee_page == 0){
            mentee_page = $scope.current_mentee_page + 1;
        } else if(mentee_page == -1){
            mentee_page = $scope.current_mentee_page - 1;
        }
        var last_mentee_page = mentee_page - 1;
        var start = (last_mentee_page * $scope.mentee_page_interval) ;
        var end = $scope.mentee_page_interval * mentee_page;
        $scope.current_mentee_page = mentee_page;
        $scope.visible_mentees = $scope.mentees.slice(start, end);
    }
    $scope.hide_popup_divs = function(){
        $('#assign_mentee_mentor').css('display', 'none');
        $('#assign_mentee_saq').css('display', 'none');
        $('#create_new_note').css('display', 'none');
    }
    $scope.assign = function(mentee){
        $scope.hide_popup_divs();
        $('#assign_mentee_mentor').css('display', 'block');
        $scope.show_popup = true;
        $scope.selected_mentee = mentee;
    }
    $scope.assign_mentee_a_mentor = function(mentor){
        params = {
            'mentor': mentor.id,
            'mentee': $scope.selected_mentee.id
        }
        $http({
            method: 'post',
            url: "/user/adminmentee",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
            $scope.mentee.status = 'ASSIGNED'
            $scope.show_popup = false; 
        }).error(function(data, success){
            console.log(data || "Request failed")
        });
    }
    $scope.assign_saq = function(saq){
        $scope.show_popup = true;
        $scope.selected_saq = saq;
        $scope.saq_mentee = '';
        $scope.hide_popup_divs();
        $('#assign_mentee_saq').css('display', 'block');
    }
    $scope.assign_mentee_a_saq = function(mentee){
        params = {
            'mentee_id': mentee.id,
            'questionnaire_id': $scope.selected_saq.id
        }
        $http({
            method: 'post',
            url: "/user/saqlist",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
        }).error(function(data, success){
        });
    }
    $scope.search_mentors = function(){

        params = {
            'key': $scope.mentor_search_key
        }
        $http({
            method: 'post',
            url: "/user/searchmentor",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {

           $scope.mentors_result = data.data;

        }).error(function(data, success){
           console.log(data || "Request failed");
        });


    }
    $scope.search_mentees = function(){

        params = {
            'key': $scope.mentee_search_key
        }
        $http({
            method: 'post',
            url: "/user/searchmentee",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {

           $scope.mentees_result = data.data;

        }).error(function(data, success){
           console.log(data || "Request failed");
        });
    }

    $scope.get_notes = function(){
        $http.get("/user/notes/").success(function(data)
        {
            $scope.menteenotes = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.create_note = function(){
        $scope.hide_popup_divs();
        $('#create_new_note').css('display', 'block');
        $scope.show_popup = true;
    }
    $scope.edit_note = function(note){
        edit_note(note, $scope);
    }
    $scope.validate_note = function(){
        validate_note($scope);
    }
    $scope.clear_current_note = function(){
        clear_current_note($scope);
    }
    $scope.save_new_note = function(){
        save_new_note($scope, $http);
    }
    $scope.delete_note = function(note){

        delete_note(note, $scope, $http);
    }
}

function MentorMenteeController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(mentor_id){
        $scope.mentor_id = mentor_id
        $scope.user_type = "Administrator";
        $scope.get_mentor_mentees();
    }
    $scope.show_menu = function(){
        $('#menu').css('display', 'block');
    }
    $scope.hide_menu = function(){
        $('#menu').css('display', 'none');
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
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
        } else if($scope.role_id == 6){
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

function AdminMenteeController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(user,role, mentee_id){
        $scope.user_id = user;
        $scope.role_id = role;
        $scope.mentee_id = mentee_id;
        console.log(mentee_id);
        $scope.show_popup = false;
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
        $scope.get_mentee_saq_list();
    }
    $scope.get_mentee_saq_list = function(){
        $http.get("/user/adminmentee/"+$scope.mentee_id).success(function(data)
        {
            $scope.mentee_saq_list = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }  
}


function AdminMenteeSAQDetailController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(user,role, saq_id){
        $scope.user_id = user;
        $scope.role_id = role;
        $scope.saq_id = saq_id;
        $scope.show_popup = false;
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
        $scope.get_saq_details();
    }
    $scope.get_saq_details = function(){
        $http.get("/user/adminsaqresult/"+$scope.saq_id).success(function(data)
        {
            $scope.saq = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }  
}

function MenteeDetailController($scope, $element, $http, $timeout, $location, $cookies)
{
    $scope.init = function(user,role, mentee_id){
        $scope.user_id = user;
        $scope.role_id = role;
        $scope.show_popup = false;
        $scope.ques_page_interval = 5;
        $scope.notes_page_interval = 5;
        $scope.shared_page_interval = 5;
        $scope.mentee_id = mentee_id;
        $scope.edit_flag = false;
        if($scope.role_id == 4){
            $scope.user_type = "Administrator";
        } else if($scope.role_id == 5){
            $scope.user_type = "Mentor";
        } else {
            $scope.user_type = "Mentee";
        }
        $scope.get_mentee_saq_list();
        $scope.get_notes();
        $scope.get_mentee_shared_notes();
        $scope.current_note = {};
        $scope.clear_current_note();

    }
    $scope.range = function(n) {
        return new Array(n);
    }
    $scope.getClass = function(page) {
        if(page == $scope.current_page)
            return "current";
        else
            return '';
    }
    $scope.get_mentee_saq_list = function(){
        $http.get("/user/adminmentee/"+$scope.mentee_id).success(function(data)
        {
            $scope.mentee_saq_list = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    
    $scope.get_mentee_shared_notes = function(){
        $http.get("/user/notes/"+$scope.mentee_id).success(function(data)
        {
            $scope.menteesharednotes = data.data;
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
    $scope.get_notes = function(){
        $http.get("/user/notes/").success(function(data)
        {
            $scope.menteenotes = data.data;
        }).error(function(data, status)
        {
            console.log(data || "Request failed");
        });
    }
    $scope.create_note = function(){
        $scope.show_popup = true;
    }
    $scope.edit_note = function(note){
        edit_note(note, $scope);
    }
    $scope.validate_note = function(){
        validate_note($scope);
    }
    $scope.clear_current_note = function(){
        clear_current_note($scope);
    }
    $scope.save_new_note = function(){
        save_new_note($scope, $http);
    }
    $scope.delete_note = function(note){

        delete_note(note, $scope, $http);
    }
}

function MenteeSAQInterface($scope, $element, $http, $timeout, $location, $cookies){
    $scope.init = function(questionare_id){
        $scope.saq_id = questionare_id;
        $scope.get_saq_details();
    }
    $scope.get_saq_details = function(){
        params = {
            'qid': $scope.saq_id,
        }
        $http({
            method: 'post',
            url: "/user/test",
            data: $.param(params),
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
            if(data.status){
                $scope.message = "Test " + data.status;
                $scope.question.answer_type = data.status;
            } else {
                $scope.question = data.question[0];
                $scope.answers = data.answer;
                if(data.answer.length > 0){
                    $scope.question.answer_type = data.answer[0].answerType;
                } else {
                    $scope.question.answer_type = 'TEXT';
                }
                $scope.question.saq_name = $scope.question.saq_name;
            }
        }).error(function(data, success){
        });
    }
    $scope.save_answer = function(){
        params = {
            'id': $scope.question.id,
            'AnswerSubmit': 1,            
        }
        if($scope.question.answer_type=='MULTISELECT'){
            params['selected_answers'] = angular.toJson($scope.question.selected_answers);
        }
        if($scope.question.answer_type=='ENUM'){
            params['selected_answers'] = angular.toJson($scope.answers);
        }
        if($scope.question.answer_type=='TEXT'){
            params['selected_answers'] = $scope.question.answer_text;
        }
        if($scope.question.answer_type=='TEXTAREA'){
            params['selected_answers'] = $scope.question.answer_textarea;
        }
        if($scope.question.answer_type=='CHECKBOX'){
            params['selected_answers'] = angular.toJson($scope.answers);
        }
        if($scope.question.answer_type=='RADIO'){
           params['selected_answers'] = $scope.question.radio_choice; 
        }
        if($scope.question.answer_type=='SELECT'){
           params['selected_answers'] = $scope.question.answer_choice; 
        }
        $http({
            method: 'post',
            url: "/user/test",
            data: $.param(params),
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
            if(data.status){
                $scope.message = "Test " + data.status;
                $scope.question.answer_type = data.status;
            } else {
                $scope.question = data.question[0];
                $scope.answers = data.answer;
                if(data.answer.length > 0){
                    $scope.question.answer_type = data.answer[0].answerType;
                } else {
                    $scope.question.answer_type = 'TEXT';
                }
                $scope.question.saq_name = $scope.question.saq_name;
            }
        }).error(function(data, success){
        });
    }
}

function SAQDetail($scope, $element, $http, $timeout, $location, $cookies){
    $scope.init = function(){

    }
    $scope.get_saq_details = function(){
        params = {
            'mentee_id': mentee.id,
            'questionnaire_id': $scope.selected_saq.id
        }
        $http({
            method: 'post',
            url: "/user/saqlist",
            data: $.param(params),
            headers: {

                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function(data, status) {
        }).error(function(data, success){
        });
    }
}
