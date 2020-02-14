# Ballerina Amazon Rekognition Connector

This connector allows to use the Amazon Rekognition service through Ballerina. The following section provide you the details on connector operations.

## Compatibility
| Ballerina Language Version 
| -------------------------- 
| 1.1.x                    


The following sections provide you with information on how to use the Amazon Rekognition Service Connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with Amazon Rekognition Service Connector actions](#working-with-amazon-rekognition-service-connector)
- [Sample](#sample)

### Contribute To develop

Clone the repository by running the following command 
```shell
git clone https://github.com/wso2-ballerina/module-amazonrekn
```

### Working with Amazon Rekognition Service Connector

First, import the `wso2/amazonrekn` module into the Ballerina project.

```ballerina
import wso2/amazonrekn;
```

In order for you to use the Amazon Rekognition Service Connector, first you need to create an Amazon Rekognition Service Connector client.

```ballerina
amazonrekn:Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY")
};

amazonrekn:Client blobClient = new(config);
```

##### Sample

```ballerina
import ballerina/config;
import ballerina/io;
import wso2/amazonrekn;
import wso2/amazoncommons;

amazonrekn:Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY")
};

amazonrekn:Client reknClient = new(config);

public function main() returns error? {
    byte[] data = check readFile("input.jpeg");
    var result1 = reknClient->detectLabels(data);
    io:println(result1);

    amazoncommons:S3Object s3obj = { bucket: "mybucket", name: "input.jpeg" };
    var result2 = reknClient->detectText(s3obj);
    io:println(result2);
}

function readFile(string path) returns byte[]|error {
    io:ReadableByteChannel ch = check io:openReadableFile(path);
    byte[] output = [];
    int i = 0;
    while (true) {
        var result = ch.read(1000);
        if (result is io:EofError) {
            break;
        }
        if (result is error) {
            return <@untainted> result;
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
    return <@untainted> output;
}
```
