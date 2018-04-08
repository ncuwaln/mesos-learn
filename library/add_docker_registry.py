import json
import os
from ansible.module_utils.basic import AnsibleModule


def add_registry(uri, auth, docker_home):
    if not os.path.isfile(docker_home+'/config.json'):
        with open(docker_home+'/config.json', 'w') as f:
            json.dump({}, f)
    with open(docker_home+'/config.json') as f:
        d = json.load(f)
        if d.get('auths') is None:
            d['auths'] = {}
        d['auths'][uri] = {}
        d['auths'][uri]['auth'] = auth
    with open(docker_home+'/config.json', 'w') as f:
        json.dump(d, f)


def main():
    module = AnsibleModule(
        argument_spec=dict(
            uri=dict(),
            auth=dict(),
            docker_home=dict(type='str', default='~/.docker')
        )
    )
    uri, auth, docker_home = module.params['uri'], module.params['auth'], module.params['docker_home']
    if uri.strip() == '':
        module.fail_json(msg='uri could not be None')
    if auth.strip() == '':
        module.fail_json(msg='auth could not be None')
    docker_home = docker_home.replace('~', os.path.expanduser('~'))
    if not os.path.isdir(docker_home):
        os.mkdir(docker_home)
    add_registry(uri, auth, docker_home)
    module.exit_json(
        uri=uri,
        docker_home=docker_home,
        msg='success'
    )


if __name__ == '__main__':
    main()
