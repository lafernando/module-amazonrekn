// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/config;
import ballerina/test;
import ballerina/io;

Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY"),
    region: "us-east-1"
};

Client reknClient = new(config);

@test:Config {}
function testDetectText() returns @tainted error? {
    byte[] data = check readFile("src/amazonrekn/tests/resources/text.jpeg");
    var result = reknClient->detectText(<@untainted> data);
    if (result is string) {
        test:assertTrue(result == "NOTHING\nEXISTS\nEXCEPT\nATOMS\nAND EMPTY\nSPACE.\nEverything else\nis opinion.");
    } else {
        test:assertTrue(false);
    }
}

@test:Config {}
function testDetectLabels() returns @tainted error? {
    byte[] data = check readFile("src/amazonrekn/tests/resources/dog-woman.jpeg");
    var result = reknClient->detectLabels(<@untainted> data);
    if (result is Label[]) {
        boolean found = false;
        foreach Label label in result {
            if (label.name == "Dog") {
                found = true;
                break;
            }
        }
        test:assertTrue(found);
    } else {
        test:assertTrue(false);
    }
}

function readFile(string path) returns @tainted byte[]|error {
    io:ReadableByteChannel ch = check io:openReadableFile(path);
    byte[] output = [];
    int i = 0;
    while (true) {
        var result = ch.read(1000);
        if (result is io:EofError) {
            break;
        }
        if (result is error) {
            return result;
        } else {
            int j = 0;
            while (j < result.length()) {
                output[i] = result[j];
                i += 1;
                j += 1;
            }
        }
    }
    check ch.close();
    return output;
}
