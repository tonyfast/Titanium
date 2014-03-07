---
layout: dataset
title: Dataset Name
dict: dictionary-for-sheep
tags: [MATERIAL TAG 1, MATERIAL TAG 2]
description: This is a dataset
input:
- {location: 'http://dropbox.com'}
execute:
- user: []
  name: []
  contact: []
aggregate:
- name: Dataset name
  native: NATIVE-DATASET-NAME
  description: A collection of homogenized information generated from a source
  input: []
  execute: []
  output:
  - {native: NATIVE-HDF-VAR-NAME-1, value: 1.0}
  - native: someshit
    value: stuff
  - {native: NATIVE-HDF-VAR-NAME-2, value: 2.0}
  workflow:
  - dict: dictionary-for-sheep
    input: []
    execute: []
    output:
    - {native: jerks, value: 6.02E23}
- native: NATIVE-DATASET-NAME
  description: A collection of homogenized information generated from a source
  output:
  - {native: NATIVE-HDF-VAR-NAME-1, value: 1.0}
  - {native: NATIVE-HDF-VAR-NAME-2, value: 2.0}
spatial:
- name: Dataset Name
  native: NATIVE-DATASET-NAME
  location: dropbox.com
  description: A collection of spatial information generated from a source
  output:
  - {native: NATIVE-HDF-VAR-NAME-1, value: www.facebook.com}
  - {native: NATIVE-HDF-VAR-NAME-4}
  viz:
  - {url: 'https://dl.dropboxusercontent.com/u/22455492/logo.png', name: An Image Title,
    description: A Short Image Description}
  workflow:
  - dict: dictionary-for-sheep
    execute:
    - sha: 06c6779e68ff64f98759c7d11a8b5f2a6543328b
      time: []
      command: ThisState(WasExecuted)
      user:
      - {name: Someone}
      - {email: Some@one.com}
    location: http://google.com
    output:
    - {native: NATIVE-HDF-VAR-NAME-2}
    viz:
    - {url: 'https://dl.dropboxusercontent.com/u/22455492/logo.png', name: An Image Title,
      description: A Short Image Description}
- name: Second Dataset
  user: First Guy
  native: NATIVE-DATASET-NAME-2
  description: A collection of spatial information generated from a source
  output:
  - {native: NATIVE-HDF-VAR-NAME-1}
  - {native: NATIVE-HDF-VAR-NAME-2}
  viz:
  - {url: 'https://dl.dropboxusercontent.com/u/22455492/logo.png', name: An Image Title,
    description: A Short Image Description}
  workflow:
  - dict: dictionary-for-sheep
    input:
    - {native: NATIVE-HDF-VAR-NAME-1, value: 2014-02-18-Dataset-Template.html}
    - {native: NATIVE-HDF-VAR-NAME-2, value: 2014-02-18-Dataset-Template.html}
    output:
    - native: NATIVE-HDF-VAR-NAME-1
      value: []
    execute:
    - user:
      - name: []
      - email: []
    - sha: []
    - exe: []
    viz:
    - {url: 'https://dl.dropboxusercontent.com/u/22455492/logo.png', name: An Image Title,
      description: A Short Image Description}
  - dict: dictionary-for-sheep
    description: This is a logo
    input:
    - {native: NATIVE-HDF-VAR-NAME-1, value: 2014-02-18-Dataset-Template.html}
    - {native: NATIVE-HDF-VAR-NAME-2}
    output:
    - {native: NATIVE-HDF-VAR-NAME-2, value: www.dropbox.com}
    execute:
    - sha: 06c6779e68ff64f98759c7d11a8b5f2a6543328b
      time: []
      command: ThisState(WasExecuted)
      user:
      - {name: Someone}
      - {email: Some@one.com}
    viz:
    - {url: 'https://dl.dropboxusercontent.com/u/22455492/logo.png', name: An Image Title,
      description: A Short Image Description}
---
