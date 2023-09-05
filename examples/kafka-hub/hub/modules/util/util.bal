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

import ballerina/random;
import ballerina/time;
import ballerina/lang.'string as strings;
import ballerina/log;

# Sanitizes the name of the `topic` by replacing special characters with `_`.
# 
# + topic - Name of the `topic`
# + return - Sanitized topic name
public isolated function sanitizeTopicName(string topic) returns string {
    return nomalizeString(topic);
}

# Generates a unique Id for a subscriber.
# 
# + topic - The `topic` which subscriber needs to subscribe
# + callbackUrl - Subscriber callback URL
# + return - Generated subscriber Id for the subscriber
public isolated function generateSubscriberId(string topic, string callbackUrl) returns string {
    string idValue = topic + ":::" + callbackUrl;
    return nomalizeString(idValue);
}

# Generates a group name for the kafka-consumer.
# 
# + topic - The `topic` which subscriber needs to subscribe
# + callbackUrl - Subscriber callback URL
# + return - Generated consumer group name the subscriber
public isolated function generateGroupName(string topic, string callbackUrl) returns string {
    string idValue = topic + ":::" + callbackUrl + ":::" + time:monotonicNow().toBalString();
    return nomalizeString(idValue);
}

# Normalizes a `string` by replacing special characters with `_`.
# 
# + baseString - `string` to be normalized
# + return - Normalized `string`
isolated function nomalizeString(string baseString) returns string {
    return re `[^a-zA-Z0-9]`.replaceAll(baseString, "_");
}

# Generates a random `string` of 10 characters
# 
# + return - The generated `string`
public isolated function generateRandomString() returns string {
    int[] codePoints = [];
    int leftLimit = 48; // numeral '0'
    int rightLimit = 122; // letter 'z'
    int iterator = 0;
    while iterator < 10 {
        int|error randomInt = random:createIntInRange(leftLimit, rightLimit);
        if randomInt is error {
            break;
        } else {
            // character literals from 48 - 57 are numbers | 65 - 90 are capital letters | 97 - 122 are simple letters
            if (randomInt <= 57 || randomInt >= 65) && (randomInt <= 90 || randomInt >= 97) {
                codePoints.push(randomInt);
                iterator += 1;
            }
        }
    }
    string|error generatedValue = strings:fromCodePointInts(codePoints);
    return generatedValue is string ? generatedValue : "";
}

# Logs errors with proper details.
#
# + msg - Base error message  
# + error - Current error
# + keyValues - Additional key values to be logged
public isolated function logError(string msg, error 'error, *log:KeyValues keyValues) {
    if !keyValues.hasKey("severity") {
        keyValues["severity"] = "RECOVERABLE";
    }
    string errorMsg = string `${msg}: ${'error.message()}`;
    error? cause = 'error.cause();
    while cause is error {
        errorMsg += string `: ${cause.message()}`;
        cause = cause.cause();
    }
    log:printError(errorMsg, stackTrace = 'error.stackTrace(), keyValues = keyValues);
}
