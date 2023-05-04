package lk.ijse.dep10.todo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Task implements Serializable {
    int id;
    String description;
    Status status;

    public  enum Status{
        completed,not_completed
    }
}
