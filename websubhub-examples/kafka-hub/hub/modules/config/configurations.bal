// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import kafkaHub.util;

# Flag to check whether to enable/disable security
public configurable boolean SECURITY_ON = true;

# Server Id which is to be used in a server cluster
public configurable string SERVER_ID = "server-1";

public configurable string REGISTERED_TOPICS = "registered-topics";
public configurable string REGISTERED_CONSUMERS = "registered-consumers";
public final string CONSTRUCTED_SERVER_ID = string`${SERVER_ID}-${util:generateRandomString()}`;