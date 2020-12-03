module.exports = {
  apps: [{
    name: 'GeyserList',
    script: 'rails',
    args: 'server -e production -p 8080 -b 127.0.0.1',
    exec_interpreter: 'ruby',
    exec_mode: 'fork_mode',
    env: {
      RAILS_SERVE_STATIC_FILES: 'enabled'
    }
  }]
}
