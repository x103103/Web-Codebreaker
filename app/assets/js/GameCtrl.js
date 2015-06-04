angular.module('Codebreaker')
    .controller('GameCtrl', [
        '$scope',
        '$http',
        '$route',
        '$routeParams',
        '$location',
        function($scope,$http,$route, $routeParams, $location){
            var default_user_code = ['-','-','-','-'];
            $scope.buttons = ['1','2','3','4','5','6'];

            $scope.user_code = angular.copy(default_user_code);
            $scope.secret_code = '';
            $scope.game;

            jQuery('[data-toggle="popover"]').popover();

            $http.get('/game').success(function(game){
                if($location.path() === '/game' && game == null) {
                    $location.path('/menu');
                } else {
                    $scope.game = angular.copy(game);
                }
            });


            if($location.path() === '/menu') {
                $http.get('/scores').success(function(scores){
                    $scope.scores = angular.copy(scores);
                });
            }




            $scope.new_game = function(){
                if(!$scope.user_name){return;}
                var post = { user_name: $scope.user_name};
                $http.post('/new_game',post).success(function(game){
                    $scope.game = angular.copy(game);
                    $location.path('/game');
                });
            };

            $scope.continue_game = function(){
                $location.path('/game');
            };

            $scope.to_menu = function(){
                $location.path('/menu');
            };

            $scope.destroy_game = function(){
                $http.get('/destroy_game').success(function(){
                    $location.path('/menu');
                });
            };

            $scope.save = function(){
                $http.get('/save').success(function(){
                    $location.path('/menu');
                });
            };

            $scope.hint = function(){
                if(!$scope.game.hint)
                $http.get('/hint').success(function(game){
                    $scope.game = angular.copy(game);
                });
            };

            var cheat_press_count = 0;
            var cheat = function(key_event){
                if($location.path() !== '/game'){return;}
                if(key_event.which !== 67 || cheat_press_count > 4) {return;}

                cheat_press_count++;
                if(cheat_press_count > 4){
                    $http.get('/cheat').success(function(secret_code){
                        $scope.secret_code = angular.copy(secret_code);
                    });
                }
            };

            var user_code_iterator = 0;
            $scope.guess = function(value){
                if($location.path() !== '/game'){return;}

                if(!value.match(/[1-6]/)){return;}

                $scope.user_code[user_code_iterator] = value;
                user_code_iterator++;
                if(user_code_iterator < 4){return;}

                var post = { user_code: $scope.user_code.join('')};

                $http.post('/guess',post).success(function(game){
                    $scope.game = angular.copy(game);
                    $scope.user_code = angular.copy(default_user_code);
                    user_code_iterator = 0;
                });
            };

            $scope.$on('keyUp', function(event, key_event) {
                cheat(key_event);
                $scope.guess(String.fromCharCode(key_event.which));
            });
        }]);
