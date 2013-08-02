<?php
/**
 * @package Hello_Dolly
 * @version 1.6
 */
/*
Plugin Name: WSU URL Handler
Description: Modifies URLs to maintain WordPress in a subdirectory with WordPress
Author: washingtonstateuniversity, jeremyfelt
Version: 0.1
Author URI: http://wsu.edu/
*/

add_filter( 'network_site_url', 'wsu_modify_network_site_url', 10, 2 );
function wsu_modify_network_site_url( $url, $path ) {
	return str_replace( $path, 'wordpress/' . $path, $url );
}
