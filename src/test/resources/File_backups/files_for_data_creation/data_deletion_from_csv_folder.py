import os
import glob
import pandas as pd
import shutil
import random
from zipfile import ZipFile


# def delete_column(csv_file, csv_destination_folders):
#     for f in csv_file:
#         df = pd.read_csv(f)
#         print('Location:', f)
#         fn = f.split("/")[-1]
#         print('File Name:', fn)
#         # print the content
#         print('Content:')
#         print(df)
#         df.pop('Title')
#         print('Edited Content:')
#         print(df)
#         df.to_csv(csv_destination_folders + fn, index=False)
#
#
# def add_column(csv_file):
#     for f in csv_file:
#         fn = f.split("/")[-1]
#         df = pd.read_csv(f)
#         n = random.randint(0, 22)
#         print(n)
#         df["minimumBillValue"] = str(n)
#         df.to_csv(csv_destination_folder + fn, index=False)
#
#
# def edit_column(csv_file):
#     for f in csv_file:
#         fn = f.split("/")[-1]
#         df = pd.read_csv(f)


def iterate_through_directories(csv_folder):
    for filename in glob.iglob(csv_folder, recursive=True):
        if os.path.isfile(filename) and filename.endswith(".csv"):  # filter dirs
            # print("file_details", filename)
            file_path = '/'.join(filename.split("/")[0:-1])
            # print("file path", file_path)
            file_name = filename.split("/")[-1]
            # print("file name", file_name)
            os.chdir(file_path)
            path = os.getcwd()
            # print(path)
            df = pd.read_csv(file_path+'/'+file_name, encoding='latin1')
            # print(df['Title'])
            df.pop('Title')
            df["Title"] = "3 % Off on Santoor Orange Soap"
            df.to_csv(file_path+'/'+file_name, index=False)


if __name__ == "__main__":
    # csv_destination_folder = r"/Users/rahul8.ranjan/Desktop/TestCases/SKU_AT_FIXED_PRICE_1/"
    csv_folder = r'/Users/rahul8.ranjan/Desktop/TestCases/SKU_AT_FIXED_PRICE/**'

    # delete_column(csv_files, csv_destination_folder)
    # add_column(csv_files)
    iterate_through_directories(csv_folder)