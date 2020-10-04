const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path")
module.exports =
{
    entry: ["./styles.scss", "./app.ts"],
    output: {
        path: path.resolve(__dirname, "../priv/static/js"),
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
                        
                    },
                    
                    {
                        loader: 'extract-loader'
                    },

                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            esModule: true
                        }
                    },

                    { loader: 'css-loader' },

                    {
                        loader: 'postcss-loader',
                        options: {
                            postcssOptions: {
                                plugins: [
                                    "autoprefixer"
                                ]
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

    plugins: [
        new MiniCssExtractPlugin(
            { filename: "[name].css", chunkFilename: "[id].css" }
        )
    ],
    resolve: {
        extensions: ['.tsx', '.ts', '.js']
    }
};