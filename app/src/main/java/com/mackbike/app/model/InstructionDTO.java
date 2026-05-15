package com.mackbike.app.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class InstructionDTO {

    @JsonProperty("text")
    private String instruction;

    @JsonProperty("street_name")
    private String streetName;

    @JsonProperty("distance")
    private double instructionDistance;
    private int time;
    private List<Integer>  interval;
    private int sign;
}
