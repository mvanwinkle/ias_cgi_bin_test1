#!/usr/bin/perl

package IAS::CGIApplication::Test;

=pod

=head1 NAME

IAS::CGIApplication::Test

=head1 DESCRIPTION

An example CGI::Application program that runs within our environment.

=cut

use strict;
use warnings;

use base 'CGI::Application';
use File::Basename;

sub setup
{
	my ($self) = @_;
	
	$self->start_mode('mode1');
	$self->mode_param('rm');
	
	$self->set_tmpl_path();
	$self->run_modes(
		'mode1' => 'do_stuff',
	);
		
}

sub set_tmpl_path
{

=pod

=head2 set_tmpl_path

We take the name of the perl module, say, Test.pm, and
set the template path to be Test/templates

=cut


	my ($self) = @_;

	my $dn = dirname(__FILE__);
	my $fn = basename(__FILE__);
	my @fn_parts = split(/\./,$fn);
	pop @fn_parts;
	my $tmpl_path = join('/',
		$dn,
		join('.', @fn_parts),
		'templates'
	);


	$self->tmpl_path($tmpl_path);
	
}

sub cgiapp_postrun
{

=pod

=head2 cgiapp_postrun

See CGI::Application documentation.

Currently we just apply a header and a footer template.

=cut

	my ($self, $output_ref) = @_;
	
	my $output = '';
	
	my $header_template = $self->load_tmpl('header.tt');
	$output .= $header_template->output();
	$output .= $$output_ref;

	my $footer_template = $self->load_tmpl('footer.tt');
	$output .= $footer_template->output();

	$$output_ref = $output;
}

sub do_stuff
{
	my ($self) = @_;
	
	my $output = '';
		
	my $html_template = $self->load_tmpl('do_stuff.tt');
	$output .= $html_template->output();
	return $output;
}

1;
