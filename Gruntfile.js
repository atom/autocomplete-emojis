'use strict';

module.exports = function (grunt) {
  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  grunt.initConfig({
    // Watches files for changes and runs tasks based on the changed files
    watch: {
      test: {
        files: ['lib/{,**/}*.coffee', 'spec/{,**/}*.coffee'],
        tasks: ['test']
      }
    },
    coffee_jshint: {
      options: {
        globals: [
          'console', 'require', 'module', '__dirname',
          'atom',
          'jasmine', 'describe', 'it', 'expect',
          'beforeEach', 'afterEach', 'waitsFor', 'waitsForPromise',
          'runs', 'advanceClock', 'spyOn'
        ]
      },
      target: {
        files: {
          code: ['lib/{,**/}*.coffee', 'spec/{,**/}*.coffee']
        }
      }
    }
  });

  grunt.registerTask('test', function (target) {
    grunt.task.run([
      'apm-test'
    ]);
  });

  grunt.registerTask('default', [
    'watch'
  ]);
};
