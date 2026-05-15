package com.mackbike.app.model;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class PathDTO {
    private double distance;
    private PointsDTO points;
    private List<InstructionDTO> instructions;
}
