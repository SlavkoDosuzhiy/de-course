import yaml


class Config:
    def __init__(self, path):
        with open(path, 'r') as cfg:
            self.config = yaml.safe_load(cfg)

    def get_config(self, app):
        return self.config[app]
