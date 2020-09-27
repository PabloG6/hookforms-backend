const path = require("path")
const autoprefixer = require("autoprefixer")
module.exports =
{
    entry: ["./styles.scss", "./app.ts"],
    output: {
        filename: 'bundle.js',
    },

    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: '/node_modules/'
            },
            {
                test: /\.s[ac]ss$/i,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: 'bundle.css',
                        }
                    },

                    {
                        loader: 'extract-loader'
                    },

                

                    { loader: 'css-loader' },
                    {
                        loader: 'postcss-loader',
                        options: {
                          postcssOptions: {
                            //   plugins: [
                            //       [
                            //           'autoprefixer',
                            //           {

                            //           }
                            //       ]
                            //   ]
                          }
                        }
                    },
                    {
                        loader: 'sass-loader',
                        options: {
                            implementation: require('sass'),
                            webpackImporter: false,
                            sassOptions: {
                                includePaths: ['./node_modules']
                            },

                        }
                    },

                ]
            },
            {
                test: /\.js$/,
                loader: 'babel-loader',
                query: {
                    presets: ['@babel/preset-env'],
                },
            }

        ]
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js']
    }
};