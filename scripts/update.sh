#!/bin/bash
apt -y update
apt list --upgradable
apt -y upgrade
