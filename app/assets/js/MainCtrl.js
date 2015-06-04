angular.module('Codebreaker')
    .controller('MainCtrl', [
        '$scope',
        '$rootScope',
        function($scope,$rootScope){
            $scope.guess = function(event){
                $rootScope.$broadcast('keyUp', event);
            };
        }]);
