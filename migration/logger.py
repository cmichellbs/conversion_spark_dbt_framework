import logging
import datetime
import pathlib

# create logger
logger = logging.getLogger("service_migration")
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)


# create formatter
formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s",
                              "%Y-%m-%d %H:%M:%S")
# add formatter to ch
ch.setFormatter(formatter)

# add ch to logger
file_handler = logging.FileHandler(f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/logs/service_migration_{datetime.datetime.today()}.log')
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)
# logger.addHandler(ch)
logger.addHandler(file_handler)
# "application" code


# if __name__ == '__main__':
#     print('olá mundo')
