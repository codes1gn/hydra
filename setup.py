from setuptools import setup, find_packages

with open("README.md") as f:
    long_description = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name="hydra", # Replace with your own username
    version="0.0.1",
    author="Enflame Tech",
    author_email="heng.shi@enflame-tech.com",
    description="accelerating python on enflame hardware",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="",
    packages=find_packages(),
    classifiers=[
    ],
    python_requires='>=2.7',
    tests_require=[
        'unittest',
    ],
)
