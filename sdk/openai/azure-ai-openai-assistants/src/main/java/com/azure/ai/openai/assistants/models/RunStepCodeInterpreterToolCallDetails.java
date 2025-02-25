// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) TypeSpec Code Generator.
package com.azure.ai.openai.assistants.models;

import com.azure.core.annotation.Generated;
import com.azure.core.annotation.Immutable;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * The detailed information about a code interpreter invocation by the model.
 */
@Immutable
public final class RunStepCodeInterpreterToolCallDetails {

    /*
     * The input provided by the model to the code interpreter tool.
     */
    @Generated
    @JsonProperty(value = "input")
    private String input;

    /*
     * The outputs produced by the code interpreter tool back to the model in response to the tool call.
     */
    @Generated
    @JsonProperty(value = "outputs")
    private List<RunStepCodeInterpreterToolCallOutput> outputs;

    /**
     * Creates an instance of RunStepCodeInterpreterToolCallDetails class.
     *
     * @param input the input value to set.
     * @param outputs the outputs value to set.
     */
    @Generated
    @JsonCreator
    private RunStepCodeInterpreterToolCallDetails(@JsonProperty(value = "input") String input,
        @JsonProperty(value = "outputs") List<RunStepCodeInterpreterToolCallOutput> outputs) {
        this.input = input;
        this.outputs = outputs;
    }

    /**
     * Get the input property: The input provided by the model to the code interpreter tool.
     *
     * @return the input value.
     */
    @Generated
    public String getInput() {
        return this.input;
    }

    /**
     * Get the outputs property: The outputs produced by the code interpreter tool back to the model in response to the
     * tool call.
     *
     * @return the outputs value.
     */
    @Generated
    public List<RunStepCodeInterpreterToolCallOutput> getOutputs() {
        return this.outputs;
    }
}
