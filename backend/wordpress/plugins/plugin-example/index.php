<?php

if (!defined('ABSPATH')) {
    exit;
}

if (!function_exists('add_action')) {
    echo "This file cannot be accessed directly.\n";
    return;
}

class PluginExample
{

    public function __construct()
    {
        add_action('init', [$this, 'init']);
    }

    public function init()
    {
        if (defined('WP_CLI') && WP_CLI) {
            return;
        }

        echo "Custom Plugin Loaded\n";
    }
}

new PluginExample();
