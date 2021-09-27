import requests
import os
import json
import datetime

from config import Config
from requests import HTTPError


def authentication(conf):
    try:
        url = conf["host"] + conf["auth_endpoint"]
        response = requests.post(url=url, data=json.dumps(conf["credentials"]), headers=conf["headers"], timeout=10)
        response.raise_for_status()
        return f'JWT {response.json().get("access_token", {})}'
    except HTTPError as e:
        print(e.response.json())


def generate_date_list(conf):
    start_date = conf.get("start_date", {})
    end_date = conf.get("end_date", {})

    if not end_date:
        end_date = datetime.date.today()
    if not start_date:
        start_date = end_date - datetime.timedelta(1)

    for n in range(int((end_date - start_date).days) + 1):
        yield start_date + datetime.timedelta(n)


def app(conf):
    try:
        config = conf.get_config("de_app_hw_1")
        token = authentication(config)
        config["headers"]["Authorization"] = token
        url = config["host"] + config["endpoint"]

        for dt in generate_date_list(config):
            day = str(dt)
            os.makedirs(os.path.join(config['dir'], day), exist_ok=True)
            data = {"date": day}
            response = requests.get(url=url, data=json.dumps(data), headers=config["headers"], timeout=10)

            with open(os.path.join(config['dir'], day, str(datetime.datetime.now()) + '.json'), 'w') as json_file:
                data = response.json()
                json.dump(data, json_file)
    except HTTPError as e:
        print(e.response.json())


if __name__ == '__main__':
    cfg = Config(os.path.join(".", "config.yaml"))
    app(cfg)


