angular.module('Codebreaker',
    [
        'ngRoute',
        'ngAnimate'
    ]).config([
        '$routeProvider',
        '$locationProvider',
        function($routeProvider, $locationProvider) {
            $routeProvider
                .when('/menu', {
                    templateUrl: 'app/views/_menu.html',
                    controller: 'GameCtrl'
                })
                .when('/game', {
                    templateUrl: 'app/views/_game.html',
                    controller: 'GameCtrl'
                })
                .otherwise('/menu');
        }]);
