# encoding=UTF-8
"""Personal mercurial hooks."""

import os

import urllib2
import json

BB_API = 'https://api.bitbucket.org/2.0/'


def add_upstream_if_fork(ui, **kwargs):
    """Add an upstream path to hgrc if we're on a fork."""
    if 'bitbucket.org' not in kwargs['pats'][0]:
        ui.warn('Upstream path cannot be set from non-bitbucket host\n')
        return False

    username, repo_slug = kwargs['pats'][0].split('/')[-2:]

    # Is the cloned repo a fork?
    try:
        response = json.loads(urllib2.urlopen(
            BB_API + '/'.join(['repositories', username, repo_slug])).read())
    except urllib2.HTTPError:
        ui.write('Repo is private; skipping fork detection.')
        return False

    if 'parent' in response:
        # It's a fork!  Add its upstream link to the cloned hgrc.
        try:
            repo_dirname = kwargs['pats'][1]
        except IndexError:
            # If no directory provided, assume the repo slug.
            repo_dirname = repo_slug
        hgrc_location = os.path.join(repo_dirname, '.hg', 'hgrc')
        hgrc_lines = open(hgrc_location, 'r').readlines()
        paths_index = hgrc_lines.index('[paths]\n')
        upstream_path = response['parent']['links']['html']['href']
        hgrc_lines.insert(
            paths_index+1,
            'upstream = %s\n' % upstream_path)

        with open(hgrc_location, 'w') as hgrc:
            hgrc.write("".join(hgrc_lines))
        ui.write('Added upstream path %s\n' % upstream_path)
    else:
        ui.warn('This repo is a parent, not a fork; Nothing to do!\n')
    return False
