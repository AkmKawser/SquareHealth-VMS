package com.starkgroup.vms.dto;

import org.springframework.data.domain.Page;

import java.util.List;

public record PagedResponse<T>(
        List<T> content,
        int page,
        int size,
        boolean hasNext,
        long totalElements,
        int totalPages
) {
    public static <T> PagedResponse<T> from(Page<T> springPage) {
        return new PagedResponse<>(
                springPage.getContent(),
                springPage.getNumber(),
                springPage.getSize(),
                springPage.hasNext(),
                springPage.getTotalElements(),
                springPage.getTotalPages()
        );
    }
}
