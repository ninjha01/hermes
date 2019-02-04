import React, { Component } from 'react';

import { withFirebase } from '../Firebase';

import LoadingSpinner from '../LoadingSpinner';

class ExerciseChangeForm extends Component {
    constructor(props) {
	super(props);
	this.state = { ...props.exercise };
	this.state.videoURL = "";
	this.state.loading = false;
	this.error = null;
    }

    onSubmit = event => {
	const fields =  {"title": this.state.title,
			 "equipment": this.state.equipment,
			 "instructions": this.state.instructions,
			 "primaryVideoID": this.state.primaryVideoID,
			 "reps": parseInt(this.state.reps),
			 "sets": parseInt(this.state.sets)}

	this.setState({loading: true})
	//WARNING: Doesn't update loading
	this.props.firebase
	    .doUpdateExerciseByID(this.state.uid, fields)
	    .catch(error => {
		this.setState({ error: error });
	    });	
	
	const videoFile = this.refs.videoUpload.files[0]
	
	if (videoFile && videoFile.size > 0) {
	    this.props.firebase //Abstract away
		.storage.ref("exercise_videos/").child(fields.primaryVideoID).put(videoFile)
		.then(() => {
		    this.setState({loading: false})
		    this.props.firebase.storage.ref('exercise_videos/')
			.child(fields.primaryVideoID)
			.getDownloadURL()
			.then((result) => {
			    this.props.firebase
				.doUpdateExerciseByID(this.state.uid,
						      {primaryVideoUrl: result})
			    this.setState({ videoURL: result })
			});
		});
	} else {
	    this.setState({loading: false});
	}
	
	event.preventDefault();
    };

    onChange = event => {
	this.setState({ [event.target.name]: event.target.value });
    };

    render() {
	const [title, videoID, videoURL,
	       instructions, equipment, reps,
	       sets, loading, error ] = [this.state.title, this.state.primaryVideoID,
					 this.state.videoURL, this.state.instructions,
					 this.state.equipment, this.state.reps,
					 this.state.sets, this.state.loading,
					 this.state.error];

	this.props.firebase.storage.ref('exercise_videos/').child(videoID)
	    .getDownloadURL()
	    .then((result) => 
		  this.setState({ videoURL: result }));

	//Validate
	const isInvalid = false;
	if (loading) {
	    return (
		    <LoadingSpinner />
	    );
	}
	else {
	    return (
	    	    <form onSubmit={this.onSubmit}>
		    <span>
		    <strong>Title:</strong>
		    <input name="title" value={title} onChange={this.onChange} type="text" placeholder="Title" />
		    <br></br>
		    </span>

		    <span>
		    <video width="500px" controls src={videoURL} onChange={this.onChange} />
		    <input ref="videoUpload" text="Update Video" onChange={this.onChange} type="file" accept='.mp4'/>
		    </span>
		    <br></br>
		    
		    <span>		
		    <strong>Instructions:</strong>
		    <input name="instructions" value={instructions} onChange={this.onChange} type="text" placeholder="Instructions" />
		    <br></br>
		    </span>

		    <span>
		    <strong>Equipment:</strong>
		    <input name="equipment" value={equipment} onChange={this.onChange} type="text" placeholder="Equipment" />
		    <br></br>
		    </span>

		    <span>
		    <strong>Reps:</strong>
		    <input name="reps" value={reps} onChange={this.onChange} type="text" placeholder="Reps" />
		    <br></br>
		    </span>

		    <span>
		    <strong>Sets:</strong>
		    <input name="sets" value={sets} onChange={this.onChange} type="text" placeholder="Sets" />
		    <br></br>
		    </span>
		    
		    <input value="Update" disabled={isInvalid} type="submit" />
		    
		{error && <p>{error.message}</p>}
		</form>
	    );
	}
    }
}
export default withFirebase(ExerciseChangeForm);
