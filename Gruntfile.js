module.exports = function(grunt)
{
    require('load-grunt-tasks')(grunt);

    grunt.initConfig(
    {

        jshint:
        {
            options:
            {
                jshintrc: '.jshintrc'
            },
            server:
            {
                src: ['index.js']
            }
        },

        coffeelint:
        {
            options:
            {
                configFile: '.coffeelint.json'
            },
            server:
            {
                files: [
                    {
                        src: ['server/**/*.coffee']
					}
				]
            }
        },

        mochaTest:
        {
            all:
            {
                options:
                {
                    reporter: 'spec',
                    require: 'coffee-script/register'
                },
                src: ['tests/**/*.coffee', 'tests/**/*.js']
            }
        }
    });

    grunt.registerTask('test', [
        'coffeelint',
        'mochaTest:all'
    ]);

    grunt.registerTask('default', ['test']);
};
